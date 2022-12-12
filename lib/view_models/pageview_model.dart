import '../common/base_view_model.dart';

class PageViewModel extends BaseViewModel{
  int _appIndex = 0;
  int get appIndex =>_appIndex;
  bool _hideBottomNav = true;
  bool get hideBottomNav => _hideBottomNav;


  void setIndex(int index){
    _appIndex = index;
    notifyListeners();
  }

  hideBottomNavigator(){
    if(!_hideBottomNav){
      _hideBottomNav=true;
      notifyListeners();
    }
  }

  showBottomNavigator(){
    if(_hideBottomNav){
      _hideBottomNav=false;
      notifyListeners();
    }
  }


}