import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class loading2 extends StatefulWidget {
  Color fromcolor;
  Color tocolor;
  loading2({Key key,@required this.fromcolor,@required this.tocolor}):super(key: key);
  @override
  _loading2State createState() => _loading2State();
}

class _loading2State extends State<loading2> with TickerProviderStateMixin{

  AnimationController animationController;
  AnimationController _controller;
  Animation animation;
  Animation animation1;
  Tween tween;
  Color fill1;
  Color fill2;

  createbubble(double begin, double end){
    animation = tween.animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(begin,end,curve: Curves.easeIn),
    ));
    animation.addListener(() {setState(() {});});
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        animationController.reverse();
      }else if(status == AnimationStatus.dismissed){
        animationController.forward();
      }
    });
    animation1 = ColorTween(begin: fill1,end: fill2).animate(_controller);
    animation1.addListener(() {setState(() {});});
    animation1.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _controller.reverse();
      }else if(status == AnimationStatus.dismissed){
        _controller.forward();
      }
    });
    return Transform.scale(
      scale: animation.value,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: animation1.value,
            radius: 8.0,
          ),
          SizedBox(width: 5.0,)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fill1 = widget.fromcolor;
    fill2 = widget.tocolor;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    tween = Tween<double>(begin: 0.0,end: 1.0);
    animationController.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          createbubble(0.0,0.2),
          createbubble(0.2,0.4),
          createbubble(0.4,0.6),
          createbubble(0.6,0.8),
          createbubble(0.8,1.0),
        ],
      ),
    );
  }
}