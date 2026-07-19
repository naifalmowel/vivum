import 'package:flutter/material.dart';

class AppProvider extends InheritedWidget {
  final String lang;
  final ThemeMode themeMode;
  final VoidCallback onToggleLang;
  final VoidCallback onToggleTheme;

  const AppProvider({
    super.key,
    required this.lang,
    required this.themeMode,
    required this.onToggleLang,
    required this.onToggleTheme,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>()!;
  }

  bool get isAr => lang == 'ar';
  bool get isDark => themeMode == ThemeMode.dark;

  String t(String key) => isAr
      ? (_ar[key] ?? _en[key] ?? key)
      : (_en[key] ?? key);

  @override
  bool updateShouldNotify(AppProvider old) => 
      old.lang != lang || old.themeMode != themeMode;

  // For backward compatibility during migration
  static AppProvider ofLegacy(BuildContext context) => of(context);

  static const _en = {
    // Nav
    'nav.home': 'Home',
    'nav.about': 'About',
    'nav.services': 'Services',
    'nav.portfolio': 'Portfolio',
    'nav.process': 'Process',
    'nav.contact': 'Contact',
    'nav.start': 'Start Project',
    'nav.lang': 'عربي',

    // Hero
    'hero.badge': 'VIVUM Digital Agency',
    'hero.headline1': 'Building Digital',
    'hero.headline2': 'Experiences That',
    'hero.headline3': 'Help Businesses Grow',
    'hero.sub': 'VIVUM combines creativity, technology, and AI to help businesses build powerful digital identities and solutions across UAE, Saudi Arabia, and Syria.',
    'hero.cta1': 'View Our Work',
    'hero.cta2': 'Start Your Project',

    // Stats
    'stats.projects': 'Projects Delivered',
    'stats.markets': 'Markets Served',
    'stats.years': 'Years of Excellence',
    'stats.satisfaction': 'Client Satisfaction',

    // Services
    'services.title': 'What We Do',
    'services.sub': 'End-to-end digital solutions crafted for the modern business landscape',
    'services.brand.title': 'Brand Identity & Creative Design',
    'services.brand.desc': 'Logo design, complete brand identity, visual guidelines, and social media branding that leaves a lasting impression.',
    'services.digital.title': 'Digital Experiences',
    'services.digital.desc': 'Website design & development, mobile applications, and e-commerce solutions that convert visitors into customers.',
    'services.ai.title': 'AI & Business Automation',
    'services.ai.desc': 'AI chatbots, WhatsApp automation, smart business solutions, and digital transformation strategies.',
    'services.it.title': 'IT Solutions',
    'services.it.desc': 'Business email, cloud services, technical support, and digital infrastructure consulting.',
    'services.learn': 'Learn More',

    // Portfolio
    'portfolio.title': 'Our Work',
    'portfolio.sub': 'Case studies from across the region',
    'portfolio.view': 'View Case Study',
    'portfolio.all': 'All',

    // Process
    'process.title': 'How We Work',
    'process.sub': 'A refined process that delivers results every time',
    'process.step1.title': 'Discovery',
    'process.step1.desc': 'Understanding your business goals, target audience, and competitive landscape through deep research.',
    'process.step2.title': 'Strategy',
    'process.step2.desc': 'Planning the optimal digital solution — architecture, tech stack, and creative direction.',
    'process.step3.title': 'Design',
    'process.step3.desc': 'Creating the visual experience: wireframes, prototypes, and pixel-perfect UI design.',
    'process.step4.title': 'Development',
    'process.step4.desc': 'Building reliable, scalable digital products with clean code and modern technologies.',
    'process.step5.title': 'Launch & Support',
    'process.step5.desc': 'Deploying with confidence and providing continuous monitoring, updates, and growth support.',

    // About
    'about.title': 'Who We Are',
    'about.story': 'VIVUM is a regional digital agency helping businesses across UAE, Saudi Arabia, and Syria transform their ideas into powerful digital experiences. We combine creative design, cutting-edge technology, and artificial intelligence to deliver solutions that drive real business growth.',
    'about.creative': 'Creative Expertise',
    'about.creative.desc': 'Award-worthy design that communicates your brand\'s story with precision and impact.',
    'about.tech': 'Technical Mastery',
    'about.tech.desc': 'Full-stack development capabilities from mobile apps to enterprise cloud infrastructure.',
    'about.ai': 'AI-Powered Innovation',
    'about.ai.desc': 'Intelligent automation and AI solutions that give your business a competitive edge.',
    'about.markets': 'Our Markets',

    // Contact
    'contact.title': 'Let\'s Build Something Great',
    'contact.sub': 'Tell us about your project and let\'s create something extraordinary together.',
    'contact.name': 'Full Name',
    'contact.email': 'Email Address',
    'contact.company': 'Company',
    'contact.service': 'Service Needed',
    'contact.message': 'Tell us about your project...',
    'contact.send': 'Send Message',
    'contact.whatsapp': 'Chat on WhatsApp',
    'contact.coverage': 'We serve clients in',
  };

  static const _ar = {
    // Nav
    'nav.home': 'الرئيسية',
    'nav.about': 'من نحن',
    'nav.services': 'خدماتنا',
    'nav.portfolio': 'أعمالنا',
    'nav.process': 'منهجيتنا',
    'nav.contact': 'تواصل معنا',
    'nav.start': 'ابدأ مشروعك',
    'nav.lang': 'English',

    // Hero
    'hero.badge': 'وكالة فيفوم الرقمية',
    'hero.headline1': 'نبني تجارب',
    'hero.headline2': 'رقمية تساعد',
    'hero.headline3': 'الأعمال على النمو',
    'hero.sub': 'فيفوم تجمع بين الإبداع والتكنولوجيا والذكاء الاصطناعي لمساعدة الأعمال على بناء هويات وحلول رقمية قوية في الإمارات والسعودية وسوريا.',
    'hero.cta1': 'شاهد أعمالنا',
    'hero.cta2': 'ابدأ مشروعك',

    // Stats
    'stats.projects': 'مشروع منجز',
    'stats.markets': 'أسواق نخدمها',
    'stats.years': 'سنوات من التميز',
    'stats.satisfaction': 'رضا العملاء',

    // Services
    'services.title': 'ما نقدمه',
    'services.sub': 'حلول رقمية متكاملة مصممة لبيئة الأعمال الحديثة',
    'services.brand.title': 'الهوية البصرية والتصميم الإبداعي',
    'services.brand.desc': 'تصميم الشعارات، الهوية البصرية الكاملة، الدليل المرئي، وتصميم وسائل التواصل الاجتماعي.',
    'services.digital.title': 'التجارب الرقمية',
    'services.digital.desc': 'تصميم وتطوير المواقع، تطبيقات الجوال، وحلول التجارة الإلكترونية.',
    'services.ai.title': 'الذكاء الاصطناعي وأتمتة الأعمال',
    'services.ai.desc': 'روبوتات الدردشة، أتمتة واتساب، الحلول الذكية، والتحول الرقمي.',
    'services.it.title': 'حلول تقنية المعلومات',
    'services.it.desc': 'البريد المؤسسي، الخدمات السحابية، الدعم التقني، واستشارات البنية التحتية.',
    'services.learn': 'اعرف أكثر',

    // Portfolio
    'portfolio.title': 'أعمالنا',
    'portfolio.sub': 'دراسات حالة من أنحاء المنطقة',
    'portfolio.view': 'عرض دراسة الحالة',
    'portfolio.all': 'الكل',

    // Process
    'process.title': 'كيف نعمل',
    'process.sub': 'منهجية متقنة تضمن النتائج في كل مرة',
    'process.step1.title': 'الاستكشاف',
    'process.step1.desc': 'فهم أهداف عملك، جمهورك المستهدف، والمشهد التنافسي من خلال بحث معمّق.',
    'process.step2.title': 'الاستراتيجية',
    'process.step2.desc': 'تخطيط الحل الرقمي الأمثل — البنية، التقنيات، والتوجه الإبداعي.',
    'process.step3.title': 'التصميم',
    'process.step3.desc': 'خلق التجربة البصرية: الهياكل الشبكية، النماذج الأولية، وتصميم واجهة المستخدم.',
    'process.step4.title': 'التطوير',
    'process.step4.desc': 'بناء منتجات رقمية موثوقة وقابلة للتطوير بكود نظيف وتقنيات حديثة.',
    'process.step5.title': 'الإطلاق والدعم',
    'process.step5.desc': 'النشر بثقة مع مراقبة مستمرة وتحديثات ودعم للنمو.',

    // About
    'about.title': 'من نحن',
    'about.story': 'فيفوم وكالة رقمية إقليمية تساعد الأعمال في الإمارات والسعودية وسوريا على تحويل أفكارها إلى تجارب رقمية قوية. نجمع التصميم الإبداعي والتكنولوجيا المتقدمة والذكاء الاصطناعي لتقديم حلول تحقق نمواً حقيقياً.',
    'about.creative': 'الخبرة الإبداعية',
    'about.creative.desc': 'تصميم استثنائي يروي قصة علامتك التجارية بدقة وتأثير.',
    'about.tech': 'التمكن التقني',
    'about.tech.desc': 'قدرات تطوير شاملة من تطبيقات الجوال إلى البنية التحتية السحابية.',
    'about.ai': 'ابتكار مدعوم بالذكاء الاصطناعي',
    'about.ai.desc': 'أتمتة ذكية وحلول AI تمنح عملك ميزة تنافسية.',
    'about.markets': 'أسواقنا',

    // Contact
    'contact.title': 'لنبني شيئاً عظيماً معاً',
    'contact.sub': 'أخبرنا عن مشروعك ولنخلق شيئاً استثنائياً معاً.',
    'contact.name': 'الاسم الكامل',
    'contact.email': 'البريد الإلكتروني',
    'contact.company': 'اسم الشركة',
    'contact.service': 'الخدمة المطلوبة',
    'contact.message': 'أخبرنا عن مشروعك...',
    'contact.send': 'إرسال الرسالة',
    'contact.whatsapp': 'تواصل عبر واتساب',
    'contact.coverage': 'نخدم عملاء في',
  };
}

// Keep alias for easier migration
typedef LanguageProvider = AppProvider;
