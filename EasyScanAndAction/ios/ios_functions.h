#ifndef D_IOS_FUNCTIONS
#define D_IOS_FUNCTIONS

#include <QString>

class ios_functions
{
public:
    static void Display(const QString& title, const QString& text);
    static void share(QString text);
    static int check_cam_permission();
};

#endif

