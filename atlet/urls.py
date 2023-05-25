from django.urls import path
from atlet.views import *
app_name = "atlet"

urlpatterns = [
    path('', show_atlet, name="show_atlet"),
    path('daftar-event', show_daftar_event, name="show_daftar_event"),
    path('daftar-event/<str:stadium>', show_pilih_event, name="show_pilih_event"),
    path('daftar-event/<str:stadium>/<str:event>', show_pilih_kategori, name="show_pilih_kategori"),
    path('enrolled-event', show_enrolled_event, name="show_enrolled_event"),
    path('create_atlet_ganda', create_atlet_ganda, name="create_atlet_ganda"),
    path('daftar-sponsor', show_daftar_sponsor, name="show_daftar_sponsor"),
]
