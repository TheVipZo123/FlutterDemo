import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      iconSize: 25,
      unselectedItemColor: Colors.black,
      unselectedFontSize: 10,
      selectedFontSize: 0,
      unselectedLabelStyle: const TextStyle(fontSize: 0),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      items: _buildBottomNavigationBarItems(),
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      onTap: onItemSelected,
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    List<String> labels = ['Geral', 'Unidade', 'Grupo'];
    List<IconData> icons = [Icons.list_alt, Icons.business_outlined, Icons.group];

    for (int i = 0; i < labels.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (i != selectedIndex) ...{
                Icon(icons[i]),
              },
              if (i == selectedIndex)
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 2, 10, 3),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(18, 38, 170, 1),
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icons[i]),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(labels[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          label: '',
        ),
      );
    }

    return items;
  }
}
