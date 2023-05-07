from django.shortcuts import render, redirect


def show_landing(request):
    return render(request, 'base.html', {})


def show_register(request):
    return render(request, 'register.html', {})


def show_login(request):
    return render(request, 'login.html', {})


def show_pertandingan(request):
    return render(request, 'pertandingan.html', {})


def daftar_atlet(request):
    return render(request, "daftar_atlet.html")


def show_list_atlet(request):
    return render(request, "list_atlet.html")


def show_dashboard_atlet(request):
    return render(request, "dashboard_atlet.html")


def show_dashboard_pelatih(request):
    return render(request, "dashboard_pelatih.html")


def show_dashboard_umpire(request):
    return render(request, "dashboard_umpire.html")


def tes_kualifikasi_atlet(request):
    return render(request, "tes_kualifikasi_atlet.html")


def isi_tes_kualifikasi_atlet(request):
    return render(request, "isi_tes_kualifikasi_atlet.html")
