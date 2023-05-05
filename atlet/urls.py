from django.urls import path
from atlet.views import *
app_name = "atlet"

urlpatterns = [
    path('', show_atlet, name="show_atlet"),
]
