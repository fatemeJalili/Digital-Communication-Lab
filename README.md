# Digital Communication Laboratory Codes

This repository contains simulations related to basic digital communication methods and basics. Simulations were accomplished in different sessions. Each folder represents one session. A list of the folders and their subject is provided below.

## List of the sessions

1. [PreLab01](#prelab01)
2. [PreLab02](#prelab02)
3. [PreLab03](#prelab03)
4. [Lab01](#lab01)
5. [Lab02](#lab02)
6. [Lab03](#lab03)
7. [Lab04](#lab04)
8. [Lab05](#lab05)
9. [Lab06](#lab06)

## PreLab01

- Working with some basic pulse shapes, plotting and observing their characteristics.
- Deriving PSK modulation bit error rate formula and plotting it versus SNR. Also comparing it to the built-in matlab ***berawgn*** function.
- Inspecting the effects of channel magnitude ($\alpha$) and pahse ($\phi$) on SER of PSK modulation.

## PreLab02

- Implementing a way to achieve a gaussian distribution using ***CLT*** theorem.
- Implementing digital filtering and comparing the results with the matlab ***filter*** built-in function. 
- Working with a sample header and data sequence, and finding out how to determine start of a data transmission process using correlation and header.
- Visualizing fft transform of a single tune signal and inspecting how different parameters (e.g. number of samples, input center frequency, and ...) affect the fft transform output.

## PreLab03

- Using matrices to calculate DFT and spectrum of a signal.
- Observing the impacts of a non-ideal transformation of a intermediate-band signal to base-band.

## Lab01

Simulations related to the white noise, filtering, base-band signals and intermediate-band signals.

## Lab02
Different steps through implementing a transmission simulation. The final goal was to send some packets of data through an ideal channel and detect them. Implemented parts are:
- Bit generation and symbol transmission:
    - ***bitGenerator*** function
    - ***grayMatrixGenerator*** function
    - bits to symbol index translation
    - ***pulseModulation*** function that could create a sequence of samples with different pulse shapes, e.g. triangular. This function creates the samples by using either the kron or the conv method.
- Symbol detection and bit reconstruction:
    - ***symbolDetection*** function with correlator or matched-filter options.
    - ***minDistanceDetector*** function
    - symbol index to bits translation
- We could also choose the constellation that we rather to use from below options:
    - PAM
    - PSK 
    - QAM

***Note:*** FSK modulations (coherenet and non-coherent) were implemented in ***lab05.m***

## Lab03
A thorough implementation of a communication system. At the transmitter header will be transmitted followed by sequence of data bits using the same functions in Lab02. Data is transferred in a noisy channel with time delay and phase offset. At the reciever the data sequence is reconstructed same as in Lab02.
The process was repeated for different SNRs to plot the bit error rate versus SNR curve. The results were the same as built-in matlab plots.

## Lab04
Contains two main files:
- ***example.m:***
    - A simple example code for getting started with ***ADALM-PLUTO (PlutoSDR)***. The code initializes the device and its required parameters. 
    - Samples of data were sent repeatedly from the tx to rx, and data frames were plotted using matlab functions simultaneously. 
- ***lab04.m:***
    - A code that implements the ***lab03.m*** process on ***ADALM-PLUTO (PlutoSDR)***.

## Lab05
It mainly focuses on completion of ***lab03.m***, mainly addding ***FSK*** modulation and simulation of it.

## Lab06
Hardware implementation of ***lab05.m*** that uses ***ADALM-PLUTO (PlutoSDR)***. Same as the ***lab04.m*** with few updates.