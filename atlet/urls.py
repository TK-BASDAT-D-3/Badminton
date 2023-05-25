from django.urls import path
from atlet.views import *
app_name = "atlet"

urlpatterns = [
    path('', show_atlet, name="show_atlet"),
    path('enrolled-event', show_enrolled_event, name="show_enrolled_event"),
    path('un-enrolled-event', un_enrolled_event, name="un_enrolled_event"),
    path('partai-peserta-kompetisi', show_all_partai_peserta_kompetisi, name="show_all_partai_peserta_kompetisi"),
    path('daftar-event', show_daftar_event, name="show_daftar_event"),
    path('daftar-sponsor-atlet', get_atlet_sponsor_data, name="get_atlet_sponsor_data"),
    path('daftar-event/<str:stadium>', show_pilih_event, name="show_pilih_event"),
    path('daftar-event/<str:stadium>/<str:event>', show_pilih_kategori, name="show_pilih_kategori"),
    path('daftar-sponsor', show_daftar_sponsor, name="show_daftar_sponsor"),
]