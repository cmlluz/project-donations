import 'dart:io';
import 'package:appdonationsgestor/components/image_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appdonationsgestor/services/profile_services.dart';
import 'package:appdonationsgestor/services/storage_service.dart';

class EditProfileController extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final StorageService _storageService = StorageService();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final pixController = TextEditingController();
  final bioController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showPasswordFields = false;
  bool get showPasswordFields => _showPasswordFields;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String? _currentProfileImageUrl;
  String? get currentProfileImageUrl => _currentProfileImageUrl;

  EditProfileController() {
    loadCurrentUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pixController.dispose();
    bioController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> loadCurrentUserData() async {
    _setLoading(true);
    try {
      final data = await _profileService.loadUserData();
      nameController.text = data['name'] ?? '';
      emailController.text =
          _profileService.currentUser?.email ?? data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      pixController.text = data['pixKey'] ?? '';
      bioController.text = data['bio'] ?? '';
      _currentProfileImageUrl = data['profilePictureUrl'];
    } catch (e) {
      print("Erro ao carregar dados: $e");
    } finally {
      _setLoading(false);
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagePickerOptionsSheet(
          onCameraTap: () {
            pickImageFromGallery(ImageSource.camera);
            Navigator.of(context).pop();
          },
          onGalleryTap: () {
            pickImageFromGallery(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> pickImageFromGallery(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void toggleShowPasswordFields(bool? value) {
    _showPasswordFields = value ?? false;
    if (!_showPasswordFields) {
      currentPasswordController.clear();
      newPasswordController.clear();
    }
    notifyListeners();
  }

  Future<String?> updateProfile() async {
    _setLoading(true);
    try {
      final user = _profileService.currentUser!;
      bool emailChanged = emailController.text.trim() != user.email;
      bool passwordChanged = newPasswordController.text.isNotEmpty;
      bool needsReauth = emailChanged || passwordChanged;

      if (needsReauth) {
        if (currentPasswordController.text.isEmpty) {
          throw Exception(
              'Senha atual é necessária para alterar email ou senha.');
        }
        await _profileService
            .reauthenticateUser(currentPasswordController.text.trim());
      }

      String? uploadedImageUrl;
      if (_selectedImage != null) {
        uploadedImageUrl = await _storageService.uploadImage(
            _selectedImage!, 'profile_images');
      }

      final updatedData = <String, dynamic>{
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'pixKey': pixController.text.trim(),
        'bio': bioController.text.trim(),
        if (uploadedImageUrl != null) 'profilePictureUrl': uploadedImageUrl,
      };

      if (emailChanged) {
        await _profileService.updateAuthEmail(emailController.text.trim());
        updatedData['email'] = emailController.text.trim();
      }

      await _profileService.updateUserProfileBackend(updatedData);

      if (passwordChanged) {
        await _profileService
            .updateAuthPassword(newPasswordController.text.trim());
      }
      return uploadedImageUrl;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}