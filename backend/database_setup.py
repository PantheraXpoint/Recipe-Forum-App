import os

# for creating the mapper code
from sqlalchemy import Column, ForeignKey, Integer, String, Boolean

# for configuration and class code
from sqlalchemy.ext.declarative import declarative_base

# for creating foreign key relationship between the tables
from sqlalchemy.orm import relationship

# for configuration
from sqlalchemy import create_engine

from flask_login import UserMixin

# create declarative_base instance
Base = declarative_base()

class Recipe(Base):
    __tablename__ = 'recipe'

    id = Column(Integer, primary_key=True)
    title = Column(String(250), nullable=False)
    image = Column(String(250), nullable=False)
    description = Column(String(250), nullable=False)
    author_id = Column(Integer, ForeignKey('account.id'))
    account = relationship("Account")

    @property
    def serialize(self):
        return {
            'title': self.title,
            'image': self.image,
            'description': self.description,
            'id': self.id,
            'author_id': self.author_id
        }

class Account(Base):
    __tablename__ = 'account'

    id = Column(Integer, primary_key=True)
    email = Column(String(250), unique=True, nullable = False)
    password = Column(String(250), nullable=False)
    
    def get_id(self):
        return str(self.id)

    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    def __eq__(self, other):
        '''
        Checks the equality of two `UserMixin` objects using `get_id`.
        '''
        if isinstance(other, UserMixin):
            return self.get_id() == other.get_id()
        return NotImplemented

    def __ne__(self, other):
        '''
        Checks the inequality of two `UserMixin` objects using `get_id`.
        '''
        equal = self.__eq__(other)
        if equal is NotImplemented:
            return NotImplemented
        return not equal

    @property
    def serialize(self):
        return {
            'id' : self.id,
            'email': self.email,
            'password': self.password,
        }
# CREATE TABLE RECIPE(
# 	REC_ID INTEGER NOT NULL IDENTITY(1,1),
# 	RATING INTEGER NOT NULL,
# 	SAVE_COUNT INTEGER NOT NULL,
# 	TITLE VARCHAR(255) NOT NULL,
# 	THUMBNAIL_URL VARCHAR(255) NOT NULL,
# 	VIEW_COUNT VARCHAR(255) NOT NULL,
# 	PROFILE_ID INTEGER NOT NULL,
# 	PRIMARY KEY (REC_ID)
# );

# creates a create_engine instance at the bottom of the file
engine = create_engine('sqlite:///recipes-collection.db')
Base.metadata.create_all(engine)