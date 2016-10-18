//
//  TransactionDetailValueCell.m
//  Blockchain
//
//  Created by Kevin Wu on 9/27/16.
//  Copyright © 2016 Blockchain Luxembourg S.A. All rights reserved.
//

#import "TransactionDetailValueCell.h"
#import "NSNumberFormatter+Currencies.h"

@implementation TransactionDetailValueCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.mainLabel setText:nil];
    [self.accessoryLabel setText:nil];
    [self.fiatValueWhenSentLabel setText:nil];
    [self.transactionFeeLabel setText:nil];
    
    [self.amountButton setHidden:YES];
    [self.accessoryButton setHidden:YES];
}

- (void)configureWithTransaction:(Transaction *)transaction
{
    [super configureWithTransaction:transaction];

    if (self.isSetup) {
        [self setupTransactionTypeText:transaction];
        self.amountButton.hidden = NO;
        self.accessoryButton.hidden = NO;
        [self setupValueWhenSentLabelText:transaction];
        self.transactionFeeLabel.text = [NSString stringWithFormat:BC_STRING_TRANSACTION_FEE_ARGUMENT, [NSNumberFormatter formatMoneyWithLocalSymbol:ABS(transaction.fee)]];
        [self.amountButton setTitle:[NSNumberFormatter formatMoneyWithLocalSymbol:ABS(transaction.amount)] forState:UIControlStateNormal];
        return;
    }
    
    // Label for Sent, Transferred, or Received
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.layoutMargins.left, self.frame.size.height/2 - 30 - 4, self.frame.size.width/3, 36)];
    self.mainLabel.adjustsFontSizeToFitWidth = YES;
    self.mainLabel.textColor = [UIColor lightGrayColor];
    self.mainLabel.font = [UIFont fontWithName:FONT_HELVETICA_NUEUE_MEDIUM size:20];
    
    [self setupTransactionTypeText:transaction];
    [self.contentView addSubview:self.mainLabel];
    
    CGFloat XPositionForAccessoryViews = self.contentView.layoutMargins.left + self.mainLabel.frame.size.width;
    
    // Amount button
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(XPositionForAccessoryViews, self.mainLabel.frame.origin.y, self.frame.size.width - XPositionForAccessoryViews - self.contentView.layoutMargins.right, 36)];
    self.amountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.amountButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.amountButton setTitle:[NSNumberFormatter formatMoneyWithLocalSymbol:ABS(transaction.amount)] forState:UIControlStateNormal];
    self.amountButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.amountButton addTarget:self action:@selector(toggleSymbol) forControlEvents:UIControlEventTouchUpInside];
    
    [self.amountButton setTitleColor:self.mainLabel.textColor forState:UIControlStateNormal];
    [self.contentView addSubview:self.amountButton];
    
    // Value when sent label
    self.fiatValueWhenSentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.layoutMargins.left, self.amountButton.frame.origin.y + self.amountButton.frame.size.height + 2, self.frame.size.width - self.contentView.layoutMargins.right - self.contentView.layoutMargins.left, 20.5)];
    self.fiatValueWhenSentLabel.font =  [UIFont systemFontOfSize:14];
    
    [self setupValueWhenSentLabelText:transaction];
    
    self.fiatValueWhenSentLabel.adjustsFontSizeToFitWidth = YES;
    self.fiatValueWhenSentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.fiatValueWhenSentLabel];
    
    // Transaction fee label
    self.transactionFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.layoutMargins.left, self.fiatValueWhenSentLabel.frame.origin.y + self.fiatValueWhenSentLabel.frame.size.height + 2, self.frame.size.width - self.contentView.layoutMargins.right - self.contentView.layoutMargins.left, 20.5)];
    self.transactionFeeLabel.font =  [UIFont systemFontOfSize:14];
    self.transactionFeeLabel.textColor = [UIColor lightGrayColor];
    self.transactionFeeLabel.text = [NSString stringWithFormat:BC_STRING_TRANSACTION_FEE_ARGUMENT, [NSNumberFormatter formatMoneyWithLocalSymbol:ABS(transaction.fee)]];
    self.transactionFeeLabel.adjustsFontSizeToFitWidth = YES;
    self.transactionFeeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.transactionFeeLabel];
    
    self.isSetup = YES;
}

- (void)setupValueWhenSentLabelText:(Transaction *)transaction
{
    //    TODO: use currencyCode instead of CURRENCY_CODE_USD when endpoint supports other currencies
    //    NSString *currencyCode = [self.detailViewDelegate getCurrencyCode];
    if ([transaction.fiatAmountsAtTime objectForKey:CURRENCY_CODE_USD]) {
        self.fiatValueWhenSentLabel.attributedText = nil;
        self.fiatValueWhenSentLabel.textColor = [UIColor lightGrayColor];
        self.fiatValueWhenSentLabel.text = [NSString stringWithFormat:BC_STRING_VALUE_WHEN_SENT_ARGUMENT, [NSNumberFormatter appendStringToFiatSymbol:[transaction.fiatAmountsAtTime objectForKey:CURRENCY_CODE_USD]]];
        self.fiatValueWhenSentLabel.hidden = NO;
    } else {
        self.fiatValueWhenSentLabel.hidden = YES;
        self.fiatValueWhenSentLabel.text = nil;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:BC_STRING_VALUE_WHEN_SENT_ARGUMENT, @".........."]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attributedString.length - 10)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(attributedString.length - 10, 10)];
        self.fiatValueWhenSentLabel.attributedText = attributedString;
    }
}

- (void)setupTransactionTypeText:(Transaction *)transaction
{
    if ([transaction.txType isEqualToString:TX_TYPE_TRANSFER]) {
        self.mainLabel.text = [BC_STRING_TRANSFERRED uppercaseString];
        self.mainLabel.textColor = COLOR_TRANSACTION_TRANSFERRED;
    } else if ([transaction.txType isEqualToString:TX_TYPE_RECEIVED]) {
        self.mainLabel.text = [BC_STRING_RECEIVED uppercaseString];
        self.mainLabel.textColor = COLOR_TRANSACTION_RECEIVED;
    } else {
        self.mainLabel.text = [BC_STRING_SENT uppercaseString];
        self.mainLabel.textColor = COLOR_TRANSACTION_SENT;
    }
}

- (void)toggleSymbol
{
    [self.valueDelegate toggleSymbol];
}

@end