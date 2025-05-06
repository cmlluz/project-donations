import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          image: const DecorationImage(
            image: NetworkImage(
                "https://imgs.search.brave.com/IzCeCU8PrEZ9T52ad2djo7oiwnH7Oue-3x_MKTRFZek/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTM1/MzMzMjI1OC9waG90/by9kb25hdGlvbi1j/b25jZXB0LXRoZS12/b2x1bnRlZXItZ2l2/aW5nLWEtZG9uYXRl/LWJveC10by10aGUt/cmVjaXBpZW50LXN0/YW5kaW5nLWFnYWlu/c3QtdGhlLXdhbGwu/d2VicD9iPTEmcz0x/NzA2NjdhJnc9MCZr/PTIwJmM9RDUzZHk0/SFBsZkxpOXlDTzhv/dW93SW45SHFJV2Zr/akV4NC1DMDVCOFRZ/VT0"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
