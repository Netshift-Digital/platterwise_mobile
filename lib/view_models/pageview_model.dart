import '../common/base_veiw_model.dart';

class PageViewModel extends BaseViewModel{
  int _appIndex = 0;
  int get appIndex =>_appIndex;

  void setIndex(int index){
    _appIndex = index;
    notifyListeners();
  }


}