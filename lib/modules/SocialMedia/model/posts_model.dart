class PostsModel{

  String? PostID;
  String? PostTitle;
  String? PostVideoID;
  String? PostDate;
  List<Object?>? PostImages;

  PostsModel(this.PostID,this.PostTitle,this.PostVideoID,this.PostDate,this.PostImages);

  PostsModel.fromJson(Map<String, dynamic> json){

    PostID = json["PostID"];
    PostTitle = json["PostTitle"];
    PostVideoID = json["PostVideoID"];
    PostDate = json["PostDate"];

    if(json["PostImages"] != null){
      json["PostImages"].forEach((element){

        PostImages!.add(element);

      });
    }

  }

  Map<String, dynamic> toMap() {
    return {
      'PostID': PostID,
      'PostTitle': PostTitle,
      'PostVideoID': PostVideoID,
      'PostDate': PostDate,
      'PostImages': PostImages,
    };
  }

}