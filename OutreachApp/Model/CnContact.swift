//
//  CnContact.swift
//  OutreachApp
//
//  Created by Demicheli, Stefano on 15/3/2563 BE.
//  Copyright © 2563 NECSI. All rights reserved.
//

import Contacts

extension CNContact {

    static let defaultKeys = [
        CNContactIdentifierKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactBirthdayKey,
        CNContactOrganizationNameKey,
        CNContactJobTitleKey,
        CNContactMiddleNameKey,
        CNContactEmailAddressesKey,
        CNContactDepartmentNameKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey,
//        CNContactNoteKey,
    ] as [CNKeyDescriptor]
}
