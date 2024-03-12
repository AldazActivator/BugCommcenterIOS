#import <Foundation/Foundation.h>

/*
     ___    __    ____  ___ _____   ____  _______    __
    /   |  / /   / __ \/   /__  /  / __ \/ ____/ |  / /
   / /| | / /   / / / / /| | / /  / / / / __/  | | / / 
  / ___ |/ /___/ /_/ / ___ |/ /__/ /_/ / /___  | |/ /  
 /_/  |_/_____/_____/_/  |_/____/_____/_____/  |___/  

*/

@interface CommCenterManager : NSObject
@end

@implementation CommCenterManager

NSString CommCenter = @"";

bool MakeCommCenterCMDA()
{
    //Directorio donde se guardará => Directory Where it will be saved
    NSString *tempCommPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"com.apple.commcenter.device_specific_nobackup.plist"];
    //digitos a lazar => random digits
    NSString *digitos = @"nUUJObFYwelR6MDJaV2JsSzRaRGIyNGpMTUlnMElsUEdJUkVMMHRtQkNQWWdWTE04TnM0SUZOCgkJPHN0cmluZz4zMGI2MGZkMC02Njc0LTQ3NzgtYmIxNC1mNGZhOTQ0MWQ0Yzg8LPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQk";
    /*
    - Longitud (18990) del "Ticket" para el Commcenter, con esto se hace la burla, Bug o Trick (como quieras decirle) 
    - Length (18990) of the "Ticket" for the Commcenter, with this the mockery, Bug or Trick is made (however you want to call it)
    */
    NSUInteger longitud = 18990;

    //aqui los obtendra a lo random -> here you will get them randomly
    NSMutableString *commcenterString = [NSMutableString string];
    for (NSUInteger i = 0; i < longitud; i++) {
        NSUInteger indice = arc4random_uniform((uint32_t)digitos.length);
        unichar caracter = [digitos characterAtIndex:indice];
        [commcenterString appendString:[NSString stringWithCharacters:&caracter length:1]];
    }
    NSData *commcenterData = [commcenterString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token = [commcenterData base64EncodedStringWithOptions:0];

    /*
        - Construimos el cuerpo del Commcenter lo Unico importante es el ActivationTicket falso, bugeado o trickeado como quieras decirle da igual
        - Con esto podras Apagar y Prender Dispositivo sin Remover baseband.

        - We build the body of the Commcenter. The only important thing is the fake, bugged or tricked ActivationTicket, whatever you want to call it, it doesn't matter.
        - With this you can turn the device on and off without removing the baseband.

    */
    NSString *commcenter = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                            @"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
                            @"<plist version=\"1.0\">\n"
                            @"<dict>\n"
                            @"    <key>is_activation_policy_locked</key>\n"
                            @"    <string>1:ktrue</string>\n"
                            @"    <key>kOperatorRoamingInfo_3GPP_CurrentOperatorBundleId</key>\n"
                            @"    <string>com.apple.Unknown-aldazactivator-368-01</string>\n"
                            @"    <key>kPostponementTicket</key>\n"
                            @"    <dict>\n"
                            @"        <key>ActivityURL</key>\n"
                            @"        <string>https://albert.apple.com/deviceservices/activity</string>\n"
                            @"        <key>ActivationTicket</key>\n"
                            @"        <string>%@</string>\n"
                            @"        <key>PhoneNumberNotificationURL</key>\n"
                            @"        <string>https://albert.apple.com/deviceservices/phoneHome</string>\n"
                            @"        <key>ActivationState</key>\n"
                            @"        <string>Activated</string>\n"
                            @"    </dict>\n"
                            @"</dict>\n"
                            @"</plist>\n", token];
    
    
    NSError *error = nil;
    [commcenter writeToFile:tempCommPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    CommCenter = [NSString stringWithFormat:@"%@/com.apple.commcenter.device_specific_nobackup.plist", NSTemporaryDirectory()];

    if (error) {
        //return no if have any error > return no si hubo uno error
        return NO;
    } else {
        // all ok > todo ok
        return YES;
    }
}

@end