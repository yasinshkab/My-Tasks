import 'package:flutter/material.dart';
import 'package:task_control/screens/auth/sign_up.dart';

Color catcolor = textgrey;
Color iconcolor = textgrey;
IconData caticon = Icons.home_filled;
categoriess(cat) {
  switch (cat) {
    case 'Technology':
      catcolor = const Color(0xFF6200EE); // Purple
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.computer; // Technology related icon
      break;

    case 'Health':
      catcolor = const Color(0xFF03DAC6); // Teal
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.local_hospital; // Health related icon
      break;

    case 'Finance':
      catcolor = const Color(0xFF03A9F4); // Light Blue
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.attach_money; // Finance related icon
      break;

    case 'Education':
      catcolor = const Color(0xFF03DAC6); // Teal
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.school; // Education related icon
      break;

    case 'Entertainment':
      catcolor = const Color(0xFFBB86FC); // Light Purple
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.movie; // Entertainment related icon
      break;

    case 'Sports':
      catcolor = const Color(0xFFCF6679); // Pink
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.sports_soccer; // Sports related icon
      break;

    case 'Travel':
      catcolor = const Color(0xFF009688); // Teal
      iconcolor = const Color(0xFFEDEDED); // Light Grey
      caticon = Icons.airplanemode_active; // Travel related icon
      break;

    case 'Food':
      catcolor = const Color(0xFFFFA000); // Amber
      iconcolor = const Color(0xFF000000); // Black
      caticon = Icons.fastfood; // Food related icon
      break;
    case 'Other':
      catcolor = Colors.grey[700]!; // Dark Grey
      iconcolor = Colors.white;
      caticon = Icons.category; // Generic icon
      // Food related icon
      break;
    default:
      catcolor = Colors.grey[700]!; // Dark Grey
      iconcolor = Colors.white;
      caticon = Icons.category; // Generic icon
      break;
  }
}
