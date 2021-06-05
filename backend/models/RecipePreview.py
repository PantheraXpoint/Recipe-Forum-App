import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
db = MongoEngine()

class RecipePreview(gj.Document):
    # recipeId = db.SequenceField()
    Id = db.IntField(required=True)
    Name = db.StringField(required=True)
    Img = db.StringField()
    Level = db.StringField(default="Dễ")
    AvgRating = db.DecimalField(required=True)
    TotalView = db.IntField(default=0)
    TotalLiked = db.IntField(defaul=0)
    TotalTime = db.IntField(default=0)
    
    meta = {'collection': 'recipe_filter'}

    # unused fields
    # dont use them
    MetaTitle = db.StringField()
    AvgRatingToString = db.StringField()
    TotalTimeString = db.StringField()
    CookTime = db.IntField()
    ImgMeta = db.StringField()
    IsLiked = db.BooleanField()
    MainIngredients = db.StringField() #wrong
    TotalIngredients = db.StringField() #wrong
    LevelId = db.IntField()
    Video = db.StringField()
    CookTimespan = db.StringField() #wrong
    TotalTimeSpan = db.StringField() # wrong
    PrepareTimeSpan = db.StringField() #wrong
    CourseName = db.StringField()
    UrlRewrite = db.StringField()
    UserInfo = db.StringField() #wrong
    TotalViewString = db.StringField()
    TotalCook = db.IntField()
    TotalReviews = db.IntField()
    CookTimeSpan = db.StringField() #wrong
    PrepareTime = db.StringField()  #wrong
    DetailUrl = db.StringField()
