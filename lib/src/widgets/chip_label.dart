// import 'package:flutter/material.dart';
// import 'package:mockani/src/utils/theme_extension.dart';

// class ChipLabel extends StatelessWidget {
//   const ChipLabel({
//     super.key,
//     required this.label,
//     required this.value,
//   });

//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     final theme = getCustomTheme(context);
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(width: 1, color: theme.onBackground),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: theme.onBackground,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//             ),
//             child: Text(
//               label,
//               style: Theme.of(context).textTheme.caption?.copyWith(
//                     color: theme.primaryBackground,
//                   ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Text(
//               value,
//               style: Theme.of(context).textTheme.caption?.copyWith(
//                     color: theme.primaryBackground,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
