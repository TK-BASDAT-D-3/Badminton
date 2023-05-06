from django.shortcuts import render, redirect


def show_landing(request):
    return render(request, 'base.html', {})


def show_register(request):
    return render(request, 'register.html', {})


def show_login(request):
    return render(request, 'login.html', {})


def show_pertandingan(request):
    return render(request, 'pertandingan.html', {})
