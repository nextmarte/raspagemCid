
from bs4 import BeautifulSoup
import requests

url = "https://www.geeksforgeeks.org/"

response = requests.get(url)

soup = BeautifulSoup(response.text, 'html.parser')

header = soup.find('div', id='header')

print(header.text)
