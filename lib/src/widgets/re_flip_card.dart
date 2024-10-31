import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:remarked_shared/src/core/ext.dart';

/// Карта лояльности, умеющая в анимацию.
///
/// Заточена под проекты ремаркед, как шаблонные, так и кастомные,
/// например, АЛьба.
///
///
class ReFlipCard extends StatelessWidget {
  /// Карта лояльности, умеющая в анимацию.
  const ReFlipCard({
    required this.percentTextStyle,
    required this.cardNumberTextStyle,
    required this.walletTextStyle,
    required this.bonusTextStyle,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.qrCodeColor,
    required this.qrCodeDecorationColor,
    required this.walletIconPath,
    required this.percent,
    required this.cardNumber,
    required this.bonus,
    required this.authorized,
    required this.authButton,
    this.imagePath,
    this.errorImagePath,
    super.key,
  });

  /// Стиль для процентов.
  final TextStyle percentTextStyle;

  /// Стиль для номера карты.
  final TextStyle cardNumberTextStyle;

  /// Стиль для баланса.
  final TextStyle walletTextStyle;

  /// Стиль для бонусов.
  final TextStyle bonusTextStyle;

  /// Цвет текста.
  final Color foregroundColor;

  /// Цвет фона.
  final Color backgroundColor;

  /// Цвет QR кода.
  final Color qrCodeColor;

  /// Цвет фона QR кода.
  final Color qrCodeDecorationColor;

  /// Путь к картинке на карте.
  final String? imagePath;

  /// Путь к картинке при ошибках.
  final String? errorImagePath;

  /// Путь к иконке валюты.
  final String walletIconPath;

  /// Процент лояльности.
  final String percent;

  /// Номер карты.
  final String cardNumber;

  /// Бонусы.
  final String bonus;

  /// Признак авторизации.
  final bool authorized;

  /// Кнопка авторизации.
  final Widget authButton;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      rotateSide: RotateSide.right,
      onTapFlipping: true,
      controller: FlipCardController(),
      frontWidget: _FrontSide(
        percentTextStyle: percentTextStyle,
        cardNumberTextStyle: cardNumberTextStyle,
        walletTextStyle: walletTextStyle,
        bonusTextStyle: bonusTextStyle,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        qrCodeColor: qrCodeColor,
        qrCodeDecorationColor: qrCodeDecorationColor,
        imagePath: imagePath,
        errorImagePath: errorImagePath,
        walletIconPath: walletIconPath,
        percent: percent,
        cardNumber: cardNumber,
        bonus: bonus,
        authorized: authorized,
        authButton: authButton,
      ),
      backWidget: _BackSide(
        backgroundColor: backgroundColor,
        qrCodeColor: qrCodeColor,
        qrCodeDecorationColor: qrCodeDecorationColor,
        cardNumber: cardNumber,
        authorized: authorized,
        authButton: authButton,
      ),
    );
  }
}

class _FrontSide extends StatefulWidget {
  const _FrontSide({
    required this.percentTextStyle,
    required this.cardNumberTextStyle,
    required this.walletTextStyle,
    required this.bonusTextStyle,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.qrCodeColor,
    required this.qrCodeDecorationColor,
    required this.walletIconPath,
    required this.percent,
    required this.cardNumber,
    required this.bonus,
    required this.authorized,
    required this.authButton,
    this.imagePath,
    this.errorImagePath,
  });

  final TextStyle percentTextStyle;

  final TextStyle cardNumberTextStyle;

  final TextStyle bonusTextStyle;

  final TextStyle walletTextStyle;

  final Color foregroundColor;

  final Color backgroundColor;

  final Color qrCodeColor;

  final Color qrCodeDecorationColor;

  final String? imagePath;

  final String? errorImagePath;

  final String walletIconPath;

  final String percent;

  final String cardNumber;

  final String bonus;

  final bool authorized;

  final Widget authButton;

  @override
  State<_FrontSide> createState() => _FrontSideState();
}

class _FrontSideState extends State<_FrontSide> {
  ImageProvider? backgroundImage;

  void _handleImageError(Object exception, StackTrace? stackTrace) {
    setState(() {
      backgroundImage = AssetImage(widget.errorImagePath ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    backgroundImage = NetworkImage(widget.imagePath ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundImage == null
            ? Colors.transparent
            : widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // boxShadow: AppColors.dropShadow,
        image: backgroundImage == null
            ? null
            : DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover,
                onError: _handleImageError,
              ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.percent,
                style: widget.percentTextStyle,
              ),
              Text(
                widget.cardNumber,
                style: widget.cardNumberTextStyle,
              ),
            ],
          ),
          const Spacer(),
          if (widget.authorized)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      widget.walletIconPath,
                      width: 24,
                      height: 24,
                      color: widget.foregroundColor,
                    ),
                    8.sbWidth,
                    Text(
                      widget.bonus,
                      style: widget.bonusTextStyle,
                    ),
                  ],
                ),
                _ColorChangingBorder(
                  child: Container(
                    width: 92,
                    height: 92,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: widget.qrCodeDecorationColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: PrettyQrView.data(
                      data: widget.cardNumber,
                      decoration: PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                          color: widget.qrCodeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            widget.authButton,
        ],
      ),
    );
  }
}

class _BackSide extends StatefulWidget {
  const _BackSide({
    required this.backgroundColor,
    required this.qrCodeColor,
    required this.qrCodeDecorationColor,
    required this.cardNumber,
    required this.authorized,
    required this.authButton,
  });

  final Color backgroundColor;

  final Color qrCodeColor;
  final Color qrCodeDecorationColor;

  final String cardNumber;

  final bool authorized;

  final Widget authButton;

  @override
  State<_BackSide> createState() => _BackSideState();
}

class _BackSideState extends State<_BackSide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 370,
      height: 232,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // boxShadow: AppColors.dropShadow,
      ),
      child: widget.authorized
          ? _ColorChangingBorder(
              child: Container(
                width: 177,
                height: 177,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: widget.qrCodeDecorationColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: PrettyQrView.data(
                  data: widget.cardNumber,
                  decoration: PrettyQrDecoration(
                    shape: PrettyQrSmoothSymbol(
                      color: widget.qrCodeColor,
                    ),
                  ),
                ),
              ),
            )
          : widget.authButton,
    );
  }
}

class _ColorChangingBorder extends StatefulWidget {
  ///
  const _ColorChangingBorder({
    required this.child,
  });

  ///
  final Widget child;

  @override
  _ColorChangingBorderState createState() => _ColorChangingBorderState();
}

///
class _ColorChangingBorderState extends State<_ColorChangingBorder> {
  Color _borderColor = Colors.white;
  Timer? _timer;
  double _brightness = 1;
  bool _isDarkening = true;
  final duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _startColorChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startColorChange() {
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (_isDarkening) {
          _brightness -= 0.1;
          if (_brightness <= 0.0) {
            _brightness = 0.0;
            _isDarkening = false;
          }
        } else {
          _brightness += 0.1;
          if (_brightness >= 1.0) {
            _brightness = 1.0;
            _isDarkening = true;
          }
        }
        _borderColor = Color.fromRGBO(
          (255 * _brightness).toInt(),
          (255 * _brightness).toInt(),
          (255 * _brightness).toInt(),
          1,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 4),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: widget.child,
      ),
    );
  }
}
