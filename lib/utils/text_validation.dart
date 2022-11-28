class TextValidator{


  static bool isValidUrl(String? e){
    bool isURLValid = Uri.parse(e.toString()).host.isNotEmpty;
     return isURLValid;
  }


  static String? minLength(String? e,{required int length,String errorMessage="below minimum length"}){
    if(length>e!.length){
      return errorMessage;
    }
    return null;
  }

}