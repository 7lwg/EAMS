import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/information/information_cubit.dart';
import 'package:graduation_project/Cubits/information/information_states.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:hexcolor/hexcolor.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final landscape = mediaQuery.orientation == Orientation.landscape;
    return BlocProvider(
      create: (context) =>
          InformationCubit()..getData(id: 'eq.${employeer_id}'),
      child: BlocConsumer<InformationCubit, InformationStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = InformationCubit.get(context);
          int salary = cubit.informationModel?.salary ?? 0;
          var currentSalaryStr = cubit.informationModel?.current_salary;
          double? currentSalaryInt;
          if (currentSalaryStr != null) {
            currentSalaryInt = double.parse(currentSalaryStr);
          }
          if (state is GetDataSuccess)
            cubit.sum_net_pay(salary, currentSalaryInt);
          cubit.set_color();

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: (landscape)
                  ? mediaQuery.size.height * (100 / 800)
                  : mediaQuery.size.height * (70 / 800),
              title: Text(
                'Salary',
                style: (landscape)
                    ? getTextWhiteHeader(context)
                    : getTextWhiteHeader(context),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, [EmployeeScreen()]);
                },
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 50,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      cubit.informationModel?.image! ??
                          'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          'Basic Salary',
                          style: TextStyle(
                            fontSize: 24,
                            color: HexColor('3232A0'),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            "${cubit.informationModel?.salary ?? ''}  ",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 12,
                  ),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: HexColor('7D7D7D'),
                  ),
                ),
                SizedBox(
                  height: 27,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        if (currentSalaryInt != null)
                          if (currentSalaryInt - salary >= 0)
                            Text('Earnings',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: HexColor('3232A0'),
                                ))
                          else if (currentSalaryInt - salary <= 0)
                            Text('deductions',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: HexColor('3232A0'),
                                )),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            '${cubit.net_pay.round()}',
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 24,
                              color: HexColor(cubit.color ?? "000000"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 12,
                  ),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: HexColor('7D7D7D'),
                  ),
                ),
                SizedBox(
                  height: 27,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          'Current Salary',
                          style: TextStyle(
                            fontSize: 24,
                            color: HexColor('3232A0'),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            '${double.parse(cubit.informationModel?.current_salary ?? '0').round()}',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 12,
                    ),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: HexColor('7D7D7D'),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
