import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.Ingredient import Ingredient
from models.Photo import Photo
from models.Profile import Profile, Creator
from models.RecipePreview import RecipePreview
db = MongoEngine()

class IngredientDetail(Ingredient):
    quantity = db.IntField(required=True)

class Step(gj.Document):
    content = db.StringField(required=True)
    photos = db.ListField(db.ListField(db.EmbeddedDocumentField(Photo))) #list of list?

class RecipeDetail(gj.Document):
    id = db.SequenceField()
    _id = db.IntField()
    name = db.StringField(required=True)
    description = db.StringField(required=True)
    photos = db.ListField(db.ListField(db.EmbeddedDocumentField(Photo))) #list of list?
    ingredients = db.ListField(db.ReferenceField(IngredientDetail))
    steps = db.ListField(db.ReferenceField(Step))

    avgRating = db.DecimalField(required=True)
    totalView = db.IntField(required=True,default=0)
    totalRating = db.IntField(default=0)
    totalLike = db.IntField(default=0)
    totalTime = db.IntField()
    level = db.StringField()
    TypeID = db.IntField(default=0)

    creator = db.EmbeddedDocumentField(Creator)

    meta = {
        'collection': 'complete_recipe_detail',
        'indexes': [
            {'fields': ['$name'],
            'default_language': 'english',
            'weights': {'name': 10}
            }
        ]
    }

    #unused fields
    servings = db.IntField()
    hasVideo = db.BooleanField()
    url = db.StringField()
    videoUrl = db.StringField()
    hasCooked = db.BooleanField()
    hasLiked = db.BooleanField()
    createdOn = db.IntField()
    totalCook = db.IntField()
    urlRewrite = db.StringField()


    def generatePreview(self):
        return RecipePreview( 
            Id=self.id,
            Name=self.name,
            AvgRating=self.avgRating,
            Img= self.getThumbnail(),
            Level= self.level,
            TotalTime = self.totalTime,
            TotalView = self.totalView,
            TotalLiked = self.totalLike
        )

    def getId(self):
        return self.id

    def getThumbnail(self):
        return self.photos[0][0]["url"]
