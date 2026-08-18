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

  String t(String key, {Map<String, String>? args}) {
    String res = (isAr ? _ar[key] : _en[key]) ?? _en[key] ?? key;
    
    if (args != null) {
      args.forEach((k, v) {
        res = res.replaceAll('{$k}', v);
      });
    }
    return res;
  }

  @override
  bool updateShouldNotify(AppProvider old) => 
      old.lang != lang || old.themeMode != themeMode;

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

    // Pricing & Packages
    'pricing.starting': 'Starting from',
    'pricing.website': 'Website',
    'pricing.branding': 'Branding',
    'pricing.ai': 'AI & Automation',
    'pricing.custom': 'Custom Quote',
    'pricing.aed': 'AED',

    'pkg.starter.title': 'Business Launch',
    'pkg.starter.price': '3,500',
    'pkg.starter.desc': 'Perfect for small businesses, startups, and new offices looking for a strong digital start.',
    'pkg.business.title': 'Growth & Identity',
    'pkg.business.price': '7,500',
    'pkg.business.desc': 'Our most popular package. A complete solution for businesses ready to scale their presence.',
    'pkg.premium.title': 'Enterprise Custom',
    'pkg.premium.price': '15,000+',
    'pkg.premium.desc': 'Custom high-end solutions with advanced technology, automation, and full support.',
    'pkg.ai.title': 'AI Business Suite',
    'pkg.ai.price': '4,000 - 8,000',
    'pkg.ai.monthly': ' + 500 - 1,500/mo',
    'pkg.ai.desc': 'Unique AI-powered automation to set your business apart from the competition.',

    // Portfolio
    'portfolio.title': 'Our Work',
    'portfolio.sub': 'Case studies from across the region',
    'portfolio.view': 'View Case Study',
    'portfolio.all': 'All',
    'portfolio.challenge': 'Challenge',
    'portfolio.solution': 'Solution',

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

    'about.label': 'WHO WE ARE',
    'about.reach.label': 'OUR REACH',
    'about.values.label': 'CORE VALUES',
    'portfolio.empty_msg': 'No projects found.. Stay tuned!',
    'portfolio.filter.cat': 'Category',
    'portfolio.filter.year': 'Year',
    'portfolio.filter.loc': 'Location',
    'portfolio.filter.skill': 'Skills',
    'process.label': 'OUR PROCESS',
    'contact.label': 'GET IN TOUCH',
    'about.title': 'Who We Are',
    'about.story': 'VIVUM is a regional digital agency helping businesses across UAE, Saudi Arabia, and Syria transform their ideas into powerful digital experiences. We combine creative design, cutting-edge technology, and artificial intelligence to deliver solutions that drive real business growth.',
    'about.foundation': 'Built on Three Foundations',
    'about.creative': 'Creative Expertise',
    'about.creative.desc': 'Award-worthy design that communicates your brand\'s story with precision and impact.',
    'about.tech': 'Technical Mastery',
    'about.tech.desc': 'Full-stack development capabilities from mobile apps to enterprise cloud infrastructure.',
    'about.ai': 'AI-Powered Innovation',
    'about.ai.desc': 'Intelligent automation and AI solutions that give your business a competitive edge.',
    'about.markets': 'Our Markets',
    'about.markets.uae.desc': 'Dubai, Abu Dhabi, Sharjah & across the Emirates',
    'about.markets.ksa.desc': 'Riyadh, Jeddah, NEOM & Vision 2030 projects',
    'about.markets.syria.desc': 'Damascus, Aleppo & the growing digital sector',
    'about.values': 'What Drives Us',
    'about.value.innovation': 'Innovation',
    'about.value.innovation.desc': 'We push creative and technical boundaries on every project.',
    'about.value.quality': 'Quality',
    'about.value.quality.desc': 'Premium output is our baseline, not our goal.',
    'about.value.partnership': 'Partnership',
    'about.value.partnership.desc': 'We build long-term relationships, not transactions.',
    'about.value.growth': 'Growth',
    'about.value.growth.desc': 'Our success is measured by your business results.',
    'pillars.title': 'Our Three Pillars',
    'pillars.label': 'WHY VIVUM',
    'hero.scroll': 'Scroll to explore',
    'services.label': 'WHAT WE DO',
    'portfolio.label': 'SELECTED WORK',
    'portfolio.empty': 'No projects found.',
    'portfolio.view_all': 'View Our Work',
    'cta.title': 'Ready to Transform Your Business?',
    'cta.sub': 'Join businesses across UAE, Saudi Arabia, and Syria who trust VIVUM.',

    // Testimonials System
    't.title': 'Success Stories',
    't.write': 'Share Your Experience',
    't.name': 'Your Name',
    't.text': 'Your Review',
    't.rating': 'Rating',
    't.submit': 'Submit Review',
    't.success': 'Thank you! Your review has been submitted for approval.',
    't.empty': 'Be the first to share your experience with VIVUM!',

    // Testimonials
    't.1': 'VIVUM transformed our digital presence. Their AI automation saved us 20 hours a week!',
    't.1.author': 'Sarah J., CEO',
    't.2': 'Professional, creative, and fast. The best agency in the region.',
    't.2.author': 'Mike R., Marketing Director',
    't.3': 'The attention to detail in the UI/UX is world-class. Highly recommended.',
    't.3.author': 'David K., Founder',
    't.4': 'Their process is so refined, it takes all the stress out of development.',
    't.4.author': 'Elena M., Product Manager',
    't.5': 'VIVUM doesn\'t just build websites; they build business growth engines.',
    't.5.author': 'James L., Serial Entrepreneur',

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

    // Footer
    'footer.company': 'Company',
    'footer.follow': 'Follow Us',
    'footer.rights': 'All rights reserved.',
    'footer.uae': 'UAE',
    'footer.ksa': 'Saudi Arabia',
    'footer.syria': 'Syria',

    'common.cancel': 'Cancel',
    'common.delete': 'Delete',
    'portfolio.delete.title': 'Delete Project?',
    'portfolio.delete.confirm': 'Are you sure you want to delete "{title}"?',
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
    'services.ai.title': 'أتمتة الأعمال والحلول الذكية',
    'services.ai.desc': 'روبوتات الدردشة، أتمتة واتساب، الحلول الذكية، والتحول الرقمي.',
    'services.it.title': 'حلول تقنية المعلومات',
    'services.it.desc': 'البريد المؤسسي، الخدمات السحابية، الدعم التقني، واستشارات البنية التحتية.',
    'services.learn': 'اعرف أكثر',

    // Pricing & Packages
    'pricing.starting': 'يبدأ من',
    'pricing.website': 'المواقع الإلكترونية',
    'pricing.branding': 'الهوية البصرية',
    'pricing.ai': 'حلول ذكية',
    'pricing.custom': 'عرض سعر مخصص',
    'pricing.aed': 'درهم',

    'pkg.starter.title': 'انطلاق الأعمال',
    'pkg.starter.price': '3,500',
    'pkg.starter.desc': 'مثالية للشركات الصغيرة، الشركات الناشئة، والمكاتب الجديدة التي تبحث عن بداية رقمية قوية.',
    'pkg.business.title': 'النمو والهوية',
    'pkg.business.price': '7,500',
    'pkg.business.desc': 'الباقة الأكثر طلباً. حل متكامل للشركات المستعدة لتوسيع حضورها الرقمي بشكل احترافي.',
    'pkg.premium.title': 'حلول مخصصة للشركات',
    'pkg.premium.price': '15,000+',
    'pkg.premium.desc': 'حلول مخصصة عالية المستوى مع تقنيات متقدمة وأتمتة ودعم كامل.',
    'pkg.ai.title': 'باقة الحلول الذكية للأعمال',
    'pkg.ai.price': '4,000 - 8,000',
    'pkg.ai.monthly': ' + 500 - 1,500/ش',
    'pkg.ai.desc': 'أتمتة فريدة مدعومة بالتقنيات الذكية لتجعل عملك متميزاً عن آلاف المنافسين.',

    // Portfolio
    'portfolio.title': 'أعمالنا',
    'portfolio.sub': 'دراسات حالة من أنحاء المنطقة',
    'portfolio.view': 'عرض دراسة الحالة',
    'portfolio.all': 'الكل',
    'portfolio.challenge': 'التحدي',
    'portfolio.solution': 'الحل',

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

    'about.label': 'من نحن',
    'about.reach.label': 'أسواقنا',
    'about.values.label': 'قيمنا الأساسية',
    'portfolio.empty_msg': 'لا توجد مشاريع حالياً.. انتظرونا قريباً!',
    'portfolio.filter.cat': 'القسم',
    'portfolio.filter.year': 'السنة',
    'portfolio.filter.loc': 'الموقع',
    'portfolio.filter.skill': 'المهارات',
    'process.label': 'منهجيتنا',
    'contact.label': 'تواصل معنا',
    'about.title': 'من نحن',
    'about.story': 'فيفوم وكالة رقمية إقليمية تساعد الأعمال في الإمارات والسعودية وسوريا على تحويل أفكارها إلى تجارب رقمية قوية. نجمع التصميم الإبداعي والتكنولوجيا المتقدمة والذكاء الاصطناعي لتقديم حلول تحقق نمواً حقيقياً.',
    'about.foundation': 'مبنية على ثلاث ركائز أساسية',
    'about.creative': 'الخبرة الإبداعية',
    'about.creative.desc': 'تصميم استثنائي يروي قصة علامتك التجارية بدقة وتأثير.',
    'about.tech': 'التمكن التقني',
    'about.tech.desc': 'قدرات تطوير شاملة من تطبيقات الجوال إلى البنية التحتية السحابية.',
    'about.ai': 'ابتكار مدعوم بأحدث التقنيات',
    'about.ai.desc': 'أتمتة ذكية وحلول تمنح عملك ميزة تنافسية.',
    'about.markets': 'أسواقنا',
    'about.markets.uae.desc': 'دبي، أبوظبي، الشارقة وكافة أنحاء الإمارات',
    'about.markets.ksa.desc': 'الرياض، جدة، نيوم ومشاريع رؤية 2030',
    'about.markets.syria.desc': 'دمشق، حلب وقطاع التكنولوجيا المتنامي',
    'about.values': 'ما الذي يدفعنا للتميز',
    'about.value.innovation': 'الابتكار',
    'about.value.innovation.desc': 'نتخطى الحدود الإبداعية والتقنية في كل مشروع.',
    'about.value.quality': 'الجودة',
    'about.value.quality.desc': 'الإنتاج المتميز هو معيارنا الأساسي، وليس مجرد هدف.',
    'about.value.partnership': 'الشراكة',
    'about.value.partnership.desc': 'نبني علاقات طويلة الأمد مع شركائنا، لا مجرد صفقات.',
    'about.value.growth': 'النمو',
    'about.value.growth.desc': 'نجاحنا يقاس بالنتائج الحقيقية التي يحققها عملك.',
    'pillars.title': 'ركائزنا الثلاث',
    'pillars.label': 'لماذا فيفوم',
    'hero.scroll': 'مرر للاستكشاف',
    'services.label': 'ما نقدمه',
    'portfolio.label': 'أعمال مختارة',
    'portfolio.empty': 'لا توجد مشاريع حالياً.',
    'portfolio.view_all': 'شاهد أعمالنا',
    'cta.title': 'جاهز لتحويل عملك؟',
    'cta.sub': 'انضم إلى الشركات في الإمارات والسعودية وسوريا التي تثق بـ فيفوم.',

    // Testimonials System
    't.title': 'قصص نجاح شركائنا',
    't.write': 'شاركنا تجربتك',
    't.name': 'الاسم الكريم',
    't.text': 'رأيك يهمنا..',
    't.rating': 'التقييم',
    't.submit': 'إرسال المراجعة',
    't.success': 'شكراً لك! تم إرسال مراجعتك وهي بانتظار المراجعة من قِبل الإدارة.',
    't.empty': 'كن أول من يشارك تجربته مع فيفوم!',

    // Testimonials
    't.1': 'فيفوم حولت حضورنا الرقمي بالكامل. أتمتة الذكاء الاصطناعي وفرت علينا 20 ساعة عمل أسبوعياً!',
    't.1.author': 'سارة ج.، مديرة تنفيذية',
    't.2': 'عمل احترافي، إبداعي، وسريع. الوكالة الأفضل في المنطقة بلا منازع.',
    't.2.author': 'مايك ر.، مدير تسويق',
    't.3': 'الاهتمام بالتفاصيل في تجربة المستخدم عالمي. أنصح بهم بشدة.',
    't.3.author': 'ديفيد ك.، مؤسس شركة',
    't.4': 'والله يا جماعة شغلهم بيبيض الوش، دقة ومواعيد متل الساعة!',
    't.4.author': 'رامي (دمشق)',
    't.5': 'من الآخر، إذا بدك تطبيق يكتسح السوق، روح لعند فيفوم وأنت مغمض.',
    't.5.author': 'أبو فهد (الرياض)',
    't.6': 'ما شاء الله، فريق مبدع وفهمان شو يعني براندينق صح.',
    't.6.author': 'نورة (دبي)',

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

    // Footer
    'footer.company': 'الشركة',
    'footer.follow': 'تابعنا',
    'footer.rights': 'جميع الحقوق محفوظة.',
    'footer.uae': 'الإمارات',
    'footer.ksa': 'السعودية',
    'footer.syria': 'سوريا',

    'common.cancel': 'إلغاء',
    'common.delete': 'حذف',
    'portfolio.delete.title': 'حذف المشروع؟',
    'portfolio.delete.confirm': 'هل أنت متأكد من حذف "{title}"؟',
  };
}
