from __future__ import division
import time


def utc_offset_convert(utc_offset):
    """ This does a UTC offset conversion from seconds to hours
    """
    offset=abs(utc_offset)
    hour=str(offset//3600)
    if len(hour)==1:
        hour=str(0)+hour

    minute=str(offset%3600//60)
    if len(minute)==1:
        minute=str(0)+minute

    if utc_offset>=0:
        sign="+"
    else:
        sign='-'

    HHMM=sign+hour+minute

    return HHMM
