from django.urls import path
from main.views import *

app_name = 'main'

urlpatterns = [
    path('', show_landing, name='show_landing'),
    path('register/', show_register, name='show_register'),
    path('login/', show_login, name='show_login'),
]
