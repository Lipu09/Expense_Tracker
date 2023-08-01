import 'package:ex2/widgets/expenses_item.dart';
import 'package:flutter/material.dart';

import 'models/expense.dart';
class ExpensesList extends StatelessWidget {
  const ExpensesList({Key? key,required this.expenses,required this.onRemoveExpense}) : super(key: key);

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: expenses.length,itemBuilder: (ctx,index)=>
      Dismissible(
          key: ValueKey(expenses[index]),
          background: Container(
           // color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            color: Color.fromARGB(45, 176, 169, 159),
            margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          onDismissed: (direction){
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expenses[index])),
    );
  }
}
