from django.urls import path
from main.views import *
from authentication.views import *

app_name = 'main'

urlpatterns = [
     path('', show_landing, name='show_landing'),
     path('register/', show_register, name='show_register'),
     path('register/atlet', show_register_atlet, name='show_register_atlet'),
     path('register/atlet/<str:nama>/<str:email>/<str:negara>/<str:tanggal_lahir>/<str:play>/<int:tinggi_badan>/<str:jenis_kelamin>', add_atlet, name='add_atlet'),
     path('register/pelatih', show_register_pelatih, name='show_register_pelatih'),
     # path('register/pelatih/<str:nama>/<str:email>/<str:negara>/<str:tanggal_lahir>/<str:play>/<int:tinggi_badan>/<str:jenis_kelamin>', add_pelatih, name='add_pelatih'),
     path('register/umpire', show_register_umpire, name='show_register_umpire'),
     path('register/umpire/<str:nama>/<str:email>/<str:negara>', add_umpire, name='add_umpire'),
     path('login/', show_login, name='show_login'),
     path('pertandingan/', show_pertandingan, name='show_pertandingan'),
     path('daftar-atlet', daftar_atlet, name="daftar_atlet"),
     path('show-list-atlet', show_list_atlet, name="show_list_atlet"),
     path('dashboard-atlet', show_dashboard_atlet, name="show_dashboard_atlet"),
     path('dashboard-pelatih', show_dashboard_pelatih, name="show_dashboard_pelatih"),
     path('dashboard-umpire', show_dashboard_umpire, name="show_dashboard_umpire"),
     path('ujian-kualifikasi', buat_ujian_kualifikasi, name="buat_ujian_kualifikasi"),
     path('ujian-kualifikasi/list', list_ujian_kualifikasi, name="list_ujian_kualifikasi"),
     path('ujian-kualifikasi/riwayat', riwayat_ujian_kualifikasi, name="riwayat_ujian_kualifikasi"),
     path('ujian-kualifikasi/tes/<int:tahun>/<int:batch>/<str:tempat>/<str:tanggal>', tes_ujian_kualifikasi, name="tes_ujian_kualifikasi"),
     path('ujian-kualifikasi/add/<int:tahun>/<int:batch>/<str:tempat>/<str:tanggal>', add_ujian_kualifikasi, name="add_ujian_kualifikasi"),
     path('ujian-kualifikasi/trigger/<int:lulus>', trigger_ujian_kualifikasi, name='trigger_ujian_kualifikasi'),
]
