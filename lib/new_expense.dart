import 'dart:math';

import 'package:ex2/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewExpense extends StatefulWidget {
  const NewExpense({Key? key,required this.onAddExpense}) : super(key: key);

  final void Function (Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController= TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async{
    final now=DateTime.now();
    final firstDate=DateTime(now.year-1,now.month,now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now
    );
    setState(() {
      _selectedDate=pickedDate;
    });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx) =>AlertDialog(
        title: Text('Invalid input'),
        content: Text('Please make sure a valid title , amount , date and category was entered'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, child: Text('Okey'))
        ],
      ));
      return;
    }

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
                      IconButton(onPressed: _presentDatePicker, icon: Icon(Icons.calendar_month))
                    ],
                  )
              ),
            ],
          ),
          SizedBox(height: 16,),
          Row(
            children:[
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase(),),),).toList(),
                  onChanged: (value){
                    setState(() {
                      if(value == null){
                        return ;
                      }
                      _selectedCategory =value;
                    });
                  }),
              Spacer(),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child:Text('Save Expense'),)
            ],
          ),
        ],
      ),
    );
  }
}