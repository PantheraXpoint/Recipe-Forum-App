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

    creator = db.EmbeddedDocumentField(Creator)

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

    meta = {'collection': 'recipe_detail'}

    def generatePreview(self):
        return RecipePreview( Id=self.id, Name=self.name, AvgRating=0.0, Img= self.getThumbnail() )

    def getId(self):
        return self.id

    def getThumbnail(self):
        return self.photos[0][0]["url"]
