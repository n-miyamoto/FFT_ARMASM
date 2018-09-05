# -*- coding: utf-8 -*-
import numpy as np

if __name__ == "__main__":
    N=4
    num=1
    f = []
    for i in range(N):
        f.append(0.25)

    F = np.fft.fft(f)/4
    print(F)

