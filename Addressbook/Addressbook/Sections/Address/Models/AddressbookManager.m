//
//  AddressbookManager.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/24.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AddressbookManager.h"

#ifdef __IPHONE_9_0

#import <Contacts/Contacts.h>

#endif

#import <AddressBook/AddressBook.h>

#import "PersonInfoModel.h"

#define iOS9_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 ? YES : NO

@implementation AddressbookManager

+ (void)xl_addressbookAuthorization:(AddressbookInfoBlock)block {
    if (iOS9_LATER) { // 在iOS9之后获取通讯录用CNContactStore
        // 已经授权了 直接返回
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            [self xl_fetchAddressbookInformation:block];
            return;
        }
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self xl_fetchAddressbookInformation:block];
            }
            else {
                [self xl_showAlert];
            }
        }];
    }
    else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusAuthorized) { // 已经授权
            [self xl_fetchAddressbookInformation:block];
            return;
        }
        
        ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self xl_fetchAddressbookInformation:block];
            }
            else {
                [self xl_showAlert];
            }
        });
        
#pragma clang diagnostic pop
        
    }
}

+ (void)xl_fetchAddressbookInformation:(AddressbookInfoBlock)block {
    if (iOS9_LATER) {
        [self xl_fetchAddressbookInformationWhenSystemVersionIsiOS9Later:block];
    }
    else {
        [self xl_fetchAddressbookInformationWhenSystemVersionIsiOS9Before:block];
    }
}

// iOS9.0 之后
+ (void)xl_fetchAddressbookInformationWhenSystemVersionIsiOS9Later:(AddressbookInfoBlock)block {
    NSMutableArray *array = [NSMutableArray array];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    // 由keys决定获取联系人的那些信息: 姓名 手机号
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    NSError *error = nil;
    [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        PersonInfoModel *model = [[PersonInfoModel alloc] init];
        
        // 联系人姓名
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName ? contact.familyName : @"", contact.givenName ? contact.givenName : @""];
        model.personName = name ? name : @"熊猫";
        
        // 联系人手机号
        NSArray *phones = contact.phoneNumbers;
        CNLabeledValue *labeledValue = phones.firstObject;
        CNPhoneNumber *phone = labeledValue.value;
        model.personPhone = phone.stringValue ? phone.stringValue : @"110";
        [array addObject:model];
    }];
    
    // 把获取到的联系人信息传过去
    block(array);
}

// iOS9.0 之前
+ (void)xl_fetchAddressbookInformationWhenSystemVersionIsiOS9Before:(AddressbookInfoBlock)block {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSMutableArray *array = [[NSMutableArray array] init];
    // 创建通讯录对象
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 从通讯录中将所有人的信息拷贝出来
    CFArrayRef allPersonInfoArray = ABAddressBookCopyArrayOfAllPeople(addressbook);
    // 获取联系人的个数
    CFIndex personCount = CFArrayGetCount(allPersonInfoArray);
    
    for (int i = 0; i < personCount; i++) {
        PersonInfoModel *model = [[PersonInfoModel alloc] init];
        // 获取其中每个联系人的信息
        ABRecordRef person = CFArrayGetValueAtIndex(allPersonInfoArray, i);
        // 联系人姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@%@", lastName ? lastName : @"", firstName ? firstName :@""];
        model.personName = name ? name : @"熊猫";
        
        // 联系人电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonDepartmentProperty);
        
//        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
        model.personPhone = phone ? phone : @"110";
        CFRelease(phones);
        [array addObject:model];
    }
    
    block(array);
    CFRelease(allPersonInfoArray);
    CFRelease(addressbook);
    
#pragma clang diagnostic pop
    
}

+ (void)xl_showAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的\"设置-隐私-通讯录\"选项中, 允许访问您的通讯录" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    [[self xl_getCurrentViewController] presentViewController:alertVC animated:YES completion:nil];
    return;
}

+ (UIViewController *)xl_getCurrentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}


@end
