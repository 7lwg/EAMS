import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/information/information_cubit.dart';
import 'package:graduation_project/Cubits/information/information_states.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/edit_number_screen.dart';
import 'package:graduation_project/Screen/employeer%20screens/employee.dart';
import 'package:graduation_project/functions/style.dart';
import 'package:hexcolor/hexcolor.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InformationCubit()..getData(id: 'eq.${employeer_id}'),
      child: BlocConsumer<InformationCubit, InformationStates>(
        listener: (context, state) {
          if (state is GetDataSuccess) {
            // getDepartments getShifts
            InformationCubit.get(context).getShifts(
                id: 'eq.${InformationCubit.get(context).informationModel!.shiftId}');
            InformationCubit.get(context).getDepartments(
                id: 'eq.${InformationCubit.get(context).informationModel!.departmentId}');
          }
        },
        builder: (context, state) {
          var cubit = InformationCubit.get(context);
          final mediaQuery = MediaQuery.of(context);
          final landscape = mediaQuery.orientation == Orientation.landscape;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: (landscape)
                  ? mediaQuery.size.height * (100 / 800)
                  : mediaQuery.size.height * (70 / 800),
              title: Text(
                'About',
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
            body: SingleChildScrollView(
              child: Column(
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
                    height: 39,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 12,
                    ),
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            'Name:',
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
                              "${cubit.informationModel?.firstName! ?? ''} ${cubit.informationModel?.lastName! ?? ''} ",
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
                          Text(
                            'Mobile No:',
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
                              '${cubit.informationModel?.phone ?? ''}',
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNumberScreen(
                                    phoneNumber: cubit.informationModel?.phone!,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                              color: HexColor('3232A0'),
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
                            'Salary: ',
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
                              '${cubit.informationModel?.salary ?? ''}',
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
                          Text(
                            'Shift:',
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
                              '${cubit.getShiftsModel?.name ?? ''}',
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
                          Text(
                            'Department:',
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
                              '${cubit.getDepartmentsModel?.name ?? ''}',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
