import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/Ingredient.dart';
import 'package:flutter_application_2/model/Step.dart' as Step;
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

class PostRecipeScreen extends StatefulWidget {
  @override
  _PostRecipeScreenState createState() => _PostRecipeScreenState();
}

class _PostRecipeScreenState extends State<PostRecipeScreen> {
  bool isBookmark = false;

  int currentTab = 0;
  final pageController = PageController();
  final listWidget = <Widget>[];

  Future<void> initDetail() async {
    setState(() {
      listWidget.add(Introduction());
      listWidget.add(Ingredients());
      listWidget.add(Steps());
    });
  }

  @override
  void initState() {
    super.initState();
    initDetail();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.pink,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.pink,
              ),
              onPressed: () {},
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: PageView(
          children: listWidget,
          controller: pageController,
          onPageChanged: (value) => setState(() => currentTab = value),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.new_label), label: "Giới thiệu"),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_food_beverage), label: "Nguyên liệu"),
            BottomNavigationBarItem(
                icon: Icon(Icons.integration_instructions), label: "Hướng dẫn"),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab,
          selectedItemColor: kSecondaryColor,
          onTap: (index) => setState(() {
            currentTab = index;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          }),
        ));
  }
}

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  File _image;
  String level = "";
  String defaultFT = "Khai vị";
  List<String> foodtype = [
    "Khai vị",
    "Tráng miệng",
    "Món Chay",
    "Món chính",
    "Ăn sáng",
    "Nhanh và dễ",
    "Thức uống",
    "Bánh",
    "Món ăn cho trẻ",
    "Món nhậu"
  ];
  void lv(String value) {
    setState(() {
      level = value;
    });
  }

  void getFoodType(String value) {
    setState(() {
      defaultFT = value;
    });
  }

  Future _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      reverse: true,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 280,
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _image == null ? Colors.grey : Colors.white,
                        image: _image == null
                            ? null
                            : DecorationImage(image: FileImage(_image))),
                    child: _image == null
                        ? Center(
                            child: Text(
                              "Nhấn để thêm hình nền",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.redAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Thịt bò xào",
                            labelText: "Tên nguyên liệu",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Mức độ:")),
                        SizedBox(
                          width: 70,
                          child: Row(
                            children: [
                              Radio(
                                  value: "Dễ",
                                  groupValue: level,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    lv(value);
                                  }),
                              Text("Dễ")
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: Row(
                            children: [
                              Radio(
                                  value: "Trung bình",
                                  groupValue: level,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    lv(value);
                                  }),
                              Text("Trung bình")
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Radio(
                                  value: "Khó",
                                  groupValue: level,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    lv(value);
                                  }),
                              Text("Khó")
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Loại món ăn:")),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton(
                              onChanged: (value) {
                                getFoodType(value);
                              },
                              iconDisabledColor: Colors.pink,
                              value: defaultFT,
                              items: foodtype.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Món ăn đậm chất truyền thống,.....",
                        labelText: "Mô tả",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}

class Ingredients extends StatefulWidget {
  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  List<Ingredient> ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ListView.builder(
            itemCount: ingredients.length + 1,
            itemBuilder: (context, index) => index == ingredients.length
                ? _IngredientInput(
                    onIngredientAdded: (value) =>
                        setState(() => ingredients.add(value)),
                  )
                : ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          setState(() => ingredients.removeAt(index)),
                    ),
                    title: Row(
                      children: [
                        SizedBox(
                          width: 185,
                          child: Text(ingredients[index].name),
                        ),
                        Expanded(
                            child: Text(
                          ingredients[index].quantity +
                              " " +
                              ingredients[index].unit,
                          textAlign: TextAlign.end,
                        ))
                      ],
                    ),
                  )),
      ),
    );
  }
}

class Steps extends StatefulWidget {
  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  List<Step.Step> steps = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemCount: steps.length + 1,
            itemBuilder: (context, index) => index == steps.length
                ? _StepInput(
                    onStepAdded: (value) => setState(() => steps.add(value)),
                    stepIndex: index + 1)
                : ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => setState(() => steps.removeAt(index)),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                              TextSpan(
                                  text: "Bước ${index + 1}: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: steps[index].content)
                            ])),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) =>
                                    Image.file(steps[index].listImageFile[i]),
                                separatorBuilder: (context, i) => SizedBox(
                                      width: 10,
                                    ),
                                itemCount: steps[index].listImageFile.length),
                          ),
                        )
                      ],
                    )),
          ),
        ),
      ),
    );
  }
}

class _StepInput extends StatefulWidget {
  final int stepIndex;
  final ValueChanged<Step.Step> onStepAdded;
  _StepInput({@required this.onStepAdded, @required this.stepIndex});

  @override
  __StepInputState createState() => __StepInputState();
}

class __StepInputState extends State<_StepInput> {
  List<File> images = [];
  String content = "";

  Future _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      images.add(File(image.path));
    });
  }

  Future _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50);
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      images.add(File(image.path));
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("Bước ${widget.stepIndex}"),
      trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            if (content.isEmpty || images.isEmpty)
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Lỗi"),
                      content: SizedBox(
                        height: 30,
                        child: Center(
                          child: Text("Vui lòng nhập đầy đủ thông tin"),
                        ),
                      )));
            else {
              widget.onStepAdded(
                  Step.Step(content: content, listImageFile: images));

              var request = http.MultipartRequest(
                  "POST", Uri.parse("http://" + BASE_URL + "/image"));
              Map<String, String> headers = {
                "Content-type": "multipart/form-data"
              };
              request.files.add(http.MultipartFile.fromBytes(
                  "image", await images[0].readAsBytes()));
              request.headers.addAll(headers);
              request.send().then((response) {
                print(response.statusCode);
                print(response.contentLength);
                print(response.reasonPhrase);
              });
            }
          }),
      title: Column(
        children: [
          TextField(
            onChanged: (value) => content = value,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Món ăn đậm chất truyền thống,.....",
              labelText: "Mô tả",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 250,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1,
              itemBuilder: (context, index) => index == images.length
                  ? GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: (Center(
                          child: Text("Thêm hình ảnh"),
                        )),
                      ))
                  : Stack(children: [
                      Image.file(images[index]),
                      IconButton(
                          onPressed: () =>
                              setState(() => images.removeAt(index)),
                          icon: Icon(Icons.delete)),
                    ]),
            ),
          )
        ],
      ),
    );
  }
}

class _IngredientInput extends StatelessWidget {
  final ValueChanged<Ingredient> onIngredientAdded;

  _IngredientInput({@required this.onIngredientAdded});

  @override
  Widget build(BuildContext context) {
    String unit = "";
    String name = "";
    String quantity = "";
    return ListTile(
      trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (unit.isEmpty || name.isEmpty || quantity.isEmpty)
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Lỗi"),
                      content: SizedBox(
                        height: 30,
                        child: Center(
                          child: Text("Vui lòng nhập đầy đủ thông tin"),
                        ),
                      )));
            else
              onIngredientAdded(
                  Ingredient(unit: unit, name: name, quantity: quantity));
          }),
      title: Row(
        children: [
          SizedBox(
            width: 175,
            child: TextFormField(
                onChanged: (value) => name = value,
                cursorColor: Colors.black,
                decoration: new InputDecoration(
                  hintText: "Tên nguyên liệu",
                  hintStyle: TextStyle(fontSize: 14),
                )),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 75,
            child: TextFormField(
              onChanged: (value) => quantity = value,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  hintText: "Số lượng", hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              onChanged: (value) => unit = value,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  hintText: "Đơn vị", hintStyle: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
