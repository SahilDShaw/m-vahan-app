#include <stdint.h>

extern "C" {
    // fernet key
    __attribute__((visibility("default"))) __attribute__((used))
    const char* get_fernet_key() {
        return "HelloWorldHelloWorldHelloWorldHe";
    }

    // certificate password
    __attribute__((visibility("default"))) __attribute__((used))
    const char* get_certificate_password() {
        return "password@123";
    }
}