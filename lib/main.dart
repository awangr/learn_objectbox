import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:object_box/entitas/objectbox.dart';
import 'package:get/get.dart';
import 'package:object_box/screen/product/views/product_screen.dart';
import 'package:objectbox/objectbox.dart';
import 'screen/sigin/views/sigin_screen.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = (await ObjectBox.create()).store;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SiginScreen(),
    );
  }
}

// class CrudScreen extends StatefulWidget {
//   const CrudScreen({super.key});

//   @override
//   State<CrudScreen> createState() => _CrudScreenState();
// }

// class _CrudScreenState extends State<CrudScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final inputController = TextEditingController();
//     final Box<Person> persons = store.box<Person>();
//     final listPersons = persons.getAll();
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: TextField(
//               controller: inputController,
//               decoration: InputDecoration(
//                   hintText: 'Input', border: OutlineInputBorder()),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//               onPressed: () {
//                 if (persons == 0)
//                   for (var e in persons.getAll()) {
//                     print('ID: ${e.id} || NAME: ${e.name}');
//                     print('___________________________');
//                   }
//               },
//               child: Text('READ')),
//           SizedBox(height: 5),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   persons.put(Person(name: inputController.text));
//                 });

//                 print('${inputController.text}');
//                 inputController.text = '';
//               },
//               child: Text('ADD')),
//           SizedBox(height: 5),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   List<String> strings = inputController.text.split('-');
//                   if (strings.length == 2) {
//                     int id = int.tryParse(strings[0]) ?? 0;
//                     if (id > 0) {
//                       persons.put(Person(id: id, name: strings[1]));
//                     }
//                   }
//                 });
//               },
//               child: Text('EDIT')),
//           SizedBox(height: 5),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   int id = int.tryParse(inputController.text) ?? 0;
//                   if (id > 0) {
//                     print(persons.remove(id).toString());
//                     Get.snackbar('Sukses', 'Berhasil delete',
//                         snackPosition: SnackPosition.BOTTOM);
//                   }
//                 });
//               },
//               child: Text('DELETE')),
//           SizedBox(height: 10),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: listPersons.length,
//             itemBuilder: (context, index) {
//               var person = listPersons[index];
//               return ListTile(
//                 title: Text('${person.name}'),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
