from django.urls import path
from atlet.views import *
app_name = "atlet"

urlpatterns = [
    path('', show_atlet, name="show_atlet"),
    path('daftar-event', show_daftar_event, name="show_daftar_event"),
    path('enrolled-event', show_enrolled_event, name="show_enrolled_event"),
    path('daftar-sponsor', show_daftar_sponsor, name="show_daftar_sponsor"),
]
