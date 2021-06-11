import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.Photo import Photo
db = MongoEngine()
from werkzeug.security import generate_password_hash, check_password_hash

class Creator(db.EmbeddedDocument):
    name = db.StringField()
    username = db.StringField()
    id = db.IntField(required=True)
    photos = db.ListField(db.EmbeddedDocumentField(Photo))
    totalFollower= db.IntField()
    totalRecipe = db.IntField()

class Rating(db.EmbeddedDocument):
    recipe_id = db.IntField()
    rating = db.FloatField()

class Profile(gj.Document):
    Id = db.SequenceField()
    UserName = db.StringField(required=True)
    PassWord = db.StringField(required=True)
    FirstName = db.StringField()
    LastName = db.StringField()
    DisplayName = db.StringField(required=True)
    AvatarUrl = db.StringField(default="https://files.catbox.moe/vfbv2r.jpg")
    TotalRecipes = db.IntField(default=0)

    #my fields
    HasLikedList = db.ListField(db.EmbeddedDocumentField(Rating),default=[])
    Collection = db.ListField(db.IntField(),default=[])

    meta = {'collection': 'account_detail'}

    def rated(self, ide):
        for i in self.HasLikedList:
            if i["recipe_id"] == ide:
                return i["rating"]
        return 0

    def check_collection(self, ide):
        for recipe in self.Collection:
            if recipe == ide:
                return 0
        return 1

    def save_to_collection(self, ide):
        self.Collection.append(ide)

    def remove_from_collection(self,ide):
        self.Collection.remove(ide)

    def get_id(self):
        return str(self.Id)

    def get_username(self):
        return str(self.UserName)

    def generateCreator(self):
        phot = Photo(url=self.AvatarUrl)
        return Creator(name=self.DisplayName, username=self.UserName, id=self.Id, photos=[phot])

    def get_collection(self):
        return self.Collection

    def add_recipe_count(self, num):
        self.TotalRecipes += num
        self.save()

    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    @property
    def getPassword(self):
        return self.PassWord

    # dont use these fields
    Cooked = db.BooleanField()
    Status = db.StringField()
    TotalFriends = db.IntField()
    PointLevelBases = db.FloatField()
    TotalFollowers = db.IntField()
    TotalPictures = db.StringField()
    Level = db.StringField()
    Avatar = db.StringField()
    Verified = db.BooleanField()
    ProfileUrl = db.StringField()
    Cover = db.StringField()
    TopRecipes = db.StringField()
    LevelName = db.StringField()
    TotalCollections = db.StringField()
    Signature = db.StringField()
    VerifyingPercent = db.StringField()
    TotalViews = db.IntField()