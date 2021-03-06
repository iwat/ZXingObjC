/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXBarcodeFormat.h"
#import "ZXProductParsedResult.h"
#import "ZXProductResultParser.h"
#import "ZXUPCEReader.h"

@implementation ZXProductResultParser

- (ZXParsedResult *)parse:(ZXResult *)result {
  ZXBarcodeFormat format = [result barcodeFormat];
  if (!(format == kBarcodeFormatUPCA || format == kBarcodeFormatUPCE || format == kBarcodeFormatEan8 || format == kBarcodeFormatEan13)) {
    return nil;
  }
  NSString * rawText = [result text];

  int length = [rawText length];
  for (int x = 0; x < length; x++) {
    unichar c = [rawText characterAtIndex:x];
    if (c < '0' || c > '9') {
      return nil;
    }
  }

  NSString * normalizedProductID;
  if (format == kBarcodeFormatUPCE) {
    normalizedProductID = [ZXUPCEReader convertUPCEtoUPCA:rawText];
  } else {
    normalizedProductID = rawText;
  }
  return [ZXProductParsedResult productParsedResultWithProductID:rawText normalizedProductID:normalizedProductID];
}

@end
