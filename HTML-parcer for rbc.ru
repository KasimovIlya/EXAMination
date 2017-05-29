#importing everything we need
from firebase import firebase
import requests
from bs4 import BeautifulSoup

class Article:
    title = ''
    text = ''
    author = ''

    def __init__(self, title, text, author):
        self.title = title
        self.text = text
        self.author = author


#preparing for parsing
urls = ["http://www.rbc.ru/rbcfreenews/592bc9ca9a7947b12f6cfafa?from=newsfeed"]
firebase_url = "https://exam-76a95.firebaseio.com/"
articles = []

for i in range(0, len(urls)):
    html_doc = requests.get(urls[i]).text
    soup = BeautifulSoup(html_doc, "lxml")
    info = soup.find("body", {"class": "news"})

    try:
        author = info.find("div", {"class" : "article__header__author-block"}).text
    except AttributeError:
        author = "no author"

    try:
        title = info.find("span", {"class" : "header__article-category__title"}).text
    except AttributeError:
        title = "no title"

    try:
        text = info.find("div", {"class" : "article__content"}).text
    except AttributeError:
        text = "no text"

    articles.append(Article(title, text, author))

db = firebase.FirebaseApplication(firebase_url)

for smth in articles:
    print(smth.__dict__)
    db.post("/articles", smth.__dict__)
