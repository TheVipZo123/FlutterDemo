import 'package:flutter/material.dart';

class NavigationProvider extends StatefulWidget {
  final Widget child;

  const NavigationProvider({super.key, required this.child});

  static _NavigationProviderState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedNavigationProvider>()!.data;
  }

  @override
  _NavigationProviderState createState() => _NavigationProviderState();
}

class _NavigationProviderState extends State<NavigationProvider> {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  Function(int) get onItemTapped => _onItemTapped;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

    set selectedIndex(int index) {
    _selectedIndex = index;
  
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNavigationProvider(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedNavigationProvider extends InheritedWidget {
  final _NavigationProviderState data;

  const _InheritedNavigationProvider({required this.data, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
