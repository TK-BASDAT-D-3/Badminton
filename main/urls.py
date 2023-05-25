from django.urls import path
from main.views import *
from authentication.views import *

app_name = 'main'

urlpatterns = [
    path('', show_landing, name='show_landing'),
    path('register/', show_register, name='show_register'),
    path('login/', show_login, name='show_login'),
    path('pertandingan/', show_pertandingan, name='show_pertandingan'),
    path('daftar-atlet', daftar_atlet, name="daftar_atlet"),
    path('show-list-atlet', show_list_atlet, name="show_list_atlet"),
    path('tes-kualifikasi-atlet', tes_kualifikasi_atlet,
         name="tes_kualifikasi_atlet"),
    path('isi-tes-kualifikasi-atlet', isi_tes_kualifikasi_atlet,
         name="isi_tes_kualifikasi_atlet"),
]
