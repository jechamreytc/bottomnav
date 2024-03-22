// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class TodoList extends StatefulWidget {
//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   final List<TodoItem> _todoItems = [];
//   String _selectedList = 'All Lists';
//   late TextEditingController _taskController;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   bool _isShowSearch = false;

//   // Voice to text variables
//   stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   String _transcription = '';

//   @override
//   void initState() {
//     super.initState();
//     _taskController = TextEditingController();
//     _initializeSpeech();
//   }

//   void _initializeSpeech() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         print('Speech recognition status: $status');
//       },
//       onError: (error) {
//         print('Speech recognition error: $error');
//       },
//     );
//     if (available) {
//       print('Speech recognition available');
//     } else {
//       print('Speech recognition not available');
//     }
//   }

//   void _startListening() {
//     _speech.listen(
//       onResult: (result) {
//         setState(() {
//           _transcription = result.recognizedWords;
//         });
//       },
//     );
//     setState(() {
//       _isListening = true;
//     });
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() {
//       _isListening = false;
//     });
//   }

//   @override
//   void dispose() {
//     _taskController.dispose();
//     super.dispose();
//   }

//   void _addTodoItem(String task, DateTime? dueDate) {
//     if (task.isNotEmpty) {
//       setState(() {
//         _todoItems.add(TodoItem(task, dueDate: dueDate));
//       });
//     }
//   }

//   void _removeTodoItem(int index) {
//     setState(() {
//       _todoItems.removeAt(index);
//     });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink, // Set app bar color
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _isShowSearch = !_isShowSearch;
//                 });
//               },
//               icon: Icon(Icons.search),
//             ),
//             !_isShowSearch
//                 ? Container()
//                 : Expanded(
//                     child: TextField(
//                       autofocus: true,
//                       controller: _taskController,
//                       decoration: InputDecoration(
//                         hintText: 'Search',
//                         // icon: Icon(Icons.search),
//                         border: InputBorder.none,
//                       ),
//                       onChanged: (value) {
//                         // Implement search functionality here
//                       },
//                     ),
//                   ),
//             SizedBox(width: 8),
//             myDropdownList(),
//           ],
//         ),
//       ),
//       body: Container(
//         color: Colors.pink.shade50, // Set page background color
//         child: _buildTodoList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddTaskPage()),
//           ).then((value) {
//             if (value != null) {
//               _addTodoItem(value['task'], value['dueDateTime']);
//             }
//           });
//         },
//         tooltip: 'Add task',
//         child: Icon(Icons.add),
//         backgroundColor: Colors.pink, // Set FAB color
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
//                   onPressed: _isListening ? _stopListening : _startListening,
//                 ),
//                 Container(
//                   width: 200, // Adjust width as needed
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Enter Quick Task Here',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//               icon: Icon(Icons.check),
//               onPressed: () {
//                 // Handle the action for the check button
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTodoList() {
//     return ListView.builder(
//       itemCount: _todoItems.length,
//       itemBuilder: (context, index) {
//         return _buildTodoItem(_todoItems[index], index);
//       },
//     );
//   }

//   String? _selectedList1 = 'All Lists';
//   final Map<String, IconData> _itemsWithIcons = {
//     'All Lists': Icons.view_list,
//     'Personal': Icons.person,
//     'Shopping': Icons.shopping_cart,
//     'Wishlist': Icons.star_border,
//     'Work': Icons.work,
//   };

//   Widget myDropdownList() {
//     return DropdownButton<String>(
//       value: _selectedList, // Use _selectedList instead of _selectedList1
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedList = newValue!; // Update _selectedList
//         });
//       },
//       items: _itemsWithIcons.entries.map<DropdownMenuItem<String>>((entry) {
//         return DropdownMenuItem<String>(
//           value: entry.key,
//           // Using a Row widget to layout the icon and text horizontally
//           child: Row(
//             children: <Widget>[
//               Icon(entry.value), // The icon
//               SizedBox(
//                   width:
//                       10), // Provide some horizontal space between the icon and the text
//               Text(entry.key), // The text
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildTodoItem(TodoItem todoItem, int index) {
//     return ListTile(
//       title: Row(
//         children: [
//           SizedBox(width: 20, child: Text(todoItem.task)),
//         ],
//       ),
//       subtitle: todoItem.dueDate != null
//           ? Text(
//               'Due Date: ${_formatDate(todoItem.dueDate!)} ${todoItem.dueTime != null ? todoItem.dueTime!.format(context) : ''}')
//           : null,
//       leading: Checkbox(
//         value: todoItem.isCompleted,
//         onChanged: (bool? value) {
//           setState(() {
//             todoItem.isCompleted = value!;
//           });
//         },
//       ),
//       onTap: () => _removeTodoItem(index),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }
// }

// class TodoItem {
//   String task;
//   bool isCompleted;
//   DateTime? dueDate;
//   TimeOfDay? dueTime;

//   TodoItem(this.task, {this.isCompleted = false, this.dueDate, this.dueTime});
// }

// class AddTaskPage extends StatefulWidget {
//   @override
//   _AddTaskPageState createState() => _AddTaskPageState();
// }

// class _AddTaskPageState extends State<AddTaskPage> {
//   late TextEditingController _taskController;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     _taskController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _taskController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add a new task'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             TextField(
//               controller: _taskController,
//               decoration: InputDecoration(
//                 labelText: 'Task',
//                 suffixIcon: Icon(Icons.assignment),
//               ),
//             ),
//             SizedBox(height: 16),
//             InkWell(
//               onTap: () {
//                 _selectDate(context);
//               },
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Due Date',
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 child: Text(_selectedDate != null
//                     ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
//                     : 'Select Date'),
//               ),
//             ),
//             SizedBox(height: 8),
//             InkWell(
//               onTap: () {
//                 _selectTime(context);
//               },
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Time',
//                   suffixIcon: Icon(Icons.access_time),
//                 ),
//                 child: Text(_selectedTime != null
//                     ? _selectedTime!.format(context)
//                     : 'Select Time'),
//               ),
//             ),
//             SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, {
//                   'task': _taskController.text,
//                   'dueDateTime': _selectedDate != null && _selectedTime != null
//                       ? DateTime(
//                           _selectedDate!.year,
//                           _selectedDate!.month,
//                           _selectedDate!.day,
//                           _selectedTime!.hour,
//                           _selectedTime!.minute,
//                         )
//                       : null,
//                 });
//               },
//               child: Text('Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
