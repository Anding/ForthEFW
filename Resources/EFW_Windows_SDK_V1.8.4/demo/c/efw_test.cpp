#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include "./EFW_filter.h"
#include <thread>
#include <chrono>
#include <cstdlib>
#include <string>
#include <cstring>

void MyDbgPrint(const char* funcName, const char* strOutPutString, ...) {
    return;
}

void delay_with_countdown(int seconds) {
    for (int i = seconds; i > 0; i--) {
        std::cout << "wait: " << i << " s..." << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
}

int main(int argc, char* argv[])
{
    EFW_INFO efwinfo;
    unsigned char major = 0, minor = 0, build = 0;
    int position;
    int idnum = EFWGetNum();
    if (idnum <= 0) {
        std::cout << "Don't find EFW Device ! " << std::endl;
        return -1;
    }
    std::cout << "idnum = " << idnum << std::endl;

    int* pPIDs = new int[idnum];
    EFW_ERROR_CODE err = EFWGetID(idnum - 1, pPIDs);
    std::cout << "EFWGetID:" << err << std::endl;

    err = EFWOpen(pPIDs[0]);
    if (err != EFW_SUCCESS) {
        std::cout << "Open EFW Failed!" << err << std::endl;
        return -1;
    }

    if (argc > 1) {
        std::string arg1 = argv[1];
        const char* version = EFWGetSDKVersion();  // 调用函数
        if (version != nullptr) {
            std::cout << "EFW SDK Version: " << version << std::endl;
        }
        else {
            std::cout << "Failed to get SDK version." << std::endl;
        }
        if (arg1 == "-v" || arg1 == "--version") {
            err = EFWGetFirmwareVersion(pPIDs[0], &major, &minor, &build);
            if (err == 0) {
                std::cout << "Firmware Version: "
                    << static_cast<int>(major) << "."
                    << static_cast<int>(minor) << "."
                    << static_cast<int>(build) << std::endl;
            }
            else {
                std::cerr << "Failed to get firmware version, error code: " << err << std::endl;
            }

            delete[] pPIDs;
            return 0;
        }
        else {
            std::cerr << "Unknown argument: " << arg1 << std::endl;
            delete[] pPIDs;
            return 1;
        }
    }
    delay_with_countdown(3);

    bool bUnidirectional = true;
    int Tar_Position = 0;
    bool runing_efw = false;
    while (true) {
        std::cout << "number 1: Calibrate" << std::endl;
        std::cout << "number 2: Get Position" << std::endl;
        std::cout << "number 3: Get Direction" << std::endl;
        std::cout << "number 4: Set Position" << std::endl;//Perform this operation (Get Property) before running.
        std::cout << "number 5: Get Property" << std::endl;
        std::cout << "To run EFW(4: Set Position), please first execute the operation(5: Get Property)." << std::endl;
        std::cout << "number (1-6),Input q exit: " << std::endl;
        std::string input;
        std::cin >> input;

        if (input == "q" || input == "Q") {
            std::cout << "Exit\n";
            break;
        }

        int choice = std::atoi(input.c_str());
        switch (choice) {
        case 1:
            std::cout << "Enter Calibrate Mode!" << std::endl;
            err = EFWCalibrate(pPIDs[0]);
            break;
        case 2:
            std::cout << "Get Position!" << std::endl;
            err = EFWGetPosition(pPIDs[0], &position);
            std::cout << "err = " << err << "Position : " << position << std::endl;
            break;
        case 3:
            std::cout << "Get Direction!" << std::endl;
            err = EFWGetDirection(pPIDs[0], &bUnidirectional);
            std::cout << "err = " << err << "bUnidirectional : " << bUnidirectional << std::endl;
            break;
        case 4: {
            if (!runing_efw) {
                std::cout << "Please execute this command(5: Get Property) first." << std::endl;
                delay_with_countdown(3);
                break;
            }
            std::cout << "Please input int: ";
            std::cin >> Tar_Position;
            std::cout << "Set Position: " << Tar_Position << std::endl;
            err = EFWSetPosition(pPIDs[0], Tar_Position);
            if (err != 0) {
                std::cerr << "EFWSetPosition fail, err code: " << err << std::endl;
            }
            break;
        }
        case 5:
            std::cout << "Get Property!" << std::endl;
            EFWGetProperty(pPIDs[0], &efwinfo);
            std::cout << "slotNum : " << efwinfo.slotNum << std::endl;
            runing_efw = true;
            break;
        case 6:
            std::cout << "mode 6" << std::endl;
            break;
        default:
            std::cout << "Invalid input. Please enter 1-6 or press q to exit.\n";
        }
    }


    delete[] pPIDs;
    std::cout << "CEFW initialized." << std::endl;
    return 0;
}





