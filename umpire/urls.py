from django.urls import path
from . import views

app_name = "umpire"

urlpatterns = [
    path('partai-kompetisi/<str:event_name>/', views.partai_kompetisi_view, name='partai_kompetisi'),
    path('insert-match/', views.insert_match_view, name='insert_match'),
    path('update-durasi/', views.update_durasi_view, name='update_durasi'),
    path('match_data/<str:event_name>/<str:babak>/', views.match_data_view, name='match_data_view'),
    path('update-point/', views.update_point_history_view, name='update_point'),
    # path('daftar-event', views.show_daftar_event, name="show_daftar_event"),
    path('daftar-event', views.show_pilih_event, name="show_pilih_event"),
    path('insert-game/', views.insert_game_data, name='insert_game'),
    path('insert-peserta-game/', views.insert_peserta_mengikuti_game_view, name='insert_peserta_game'),
    path('insert-peserta-match/', views.insert_peserta_mengikuti_match_view, name='insert_peserta_match'),
]
