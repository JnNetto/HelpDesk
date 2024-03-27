import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../util/AppCollors.dart';
import '../../util/dados_gerais.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    String? nome = GeneralData.currentUser?.name;
    return Consumer<EditProfileController>(builder:
        (BuildContext context, EditProfileController value, Widget? child) {
      EditProfileController editProfileController =
          Provider.of<EditProfileController>(context);

      return Stack(
        children: [
          Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(152),
                child: Row(
                  children: [
                    Expanded(
                      flex: 17,
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: ListTile(
                          title: Text(
                            'HelpDesk',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 40,
                                    color: AppCollors.textColorBlue,
                                    fontWeight: FontWeight.w600)),
                          ),
                          subtitle: Text(
                            'Aqui você pode editar seu perfil pessoal $nome!',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: 15,
                              color: AppCollors.textColorBlue,
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 15, top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppCollors.primaryColor,
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          minRadius: 100,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: AppCollors.primaryColor,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          GeneralData.currentUser?.name ?? '',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 40,
                                  color: AppCollors.textColorBlue)),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return editProfileController
                                      .editName(context);
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: AppCollors.primaryColor,
                            ))
                      ],
                    ),
                  ],
                ),
              )),
        ],
      );
    });
  }
}
