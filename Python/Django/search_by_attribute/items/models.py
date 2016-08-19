# -*- coding: utf-8 -*-

from django.db import models


class Item(models.Model):

    sku = models.PositiveIntegerField()
    link = models.CharField(max_length=2000)
    brand = models.CharField(max_length=200)
