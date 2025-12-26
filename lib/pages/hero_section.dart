import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hwl_portforlio/main.dart';
import 'package:hwl_portforlio/pages/education.dart';
import 'dart:html' as html;
import 'package:hwl_portforlio/pages/experience.dart';
import 'package:hwl_portforlio/pages/project.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HeroSection extends StatefulWidget {
  final String page;
  const HeroSection({
    super.key,
    required this.page,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // Add controllers to get the text field values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // Scroll controller for smooth scrolling
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section

  final GlobalKey _experiencesKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Back to top button visibility
  bool _showBackToTop = false;

  // Animation controllers for scroll-triggered animations
  late AnimationController _mainController;
  late AnimationController _experiencesController;
  late AnimationController _educationController;
  late AnimationController _projectsController;
  late AnimationController _contactController;

  // Main animations
  // late Animation<double> _imageScaleAnimation;
  // late Animation<double> _navbarFadeAnimation;

  // Section animations
  late Animation<double> _experiencesFadeAnimation;
  late Animation<double> _educationFadeAnimation;
  late Animation<double> _projectsFadeAnimation;
  late Animation<double> _contactFadeAnimation;

  final List<Experience> _experiences = const [
    Experience(
      title: 'Software Engineer',
      company: 'Whatif Solutions Sdn Bhd',
      duration: 'May 2025 - Dec 2025',
      responsibilities: [
        "Owned production stability for IoT smart-home and online social mobile applications, supporting user interactions and operational reliability",
        "Took ownership of legacy codebases, performing targeted refactoring and rapid bug fixes, reducing critical issue resolution time from multiple days to same-day turnaround",
        "Collaborated with backend and system teams to ensure full reliable data flow and secure transaction handling for business-critical modules",
        "Improved application responsiveness and performance, shortening average user interaction wait times by 2-3 seconds across key flows",
        "Supported client-facing delivery timelines by proactively resolving production issues, preventing release delays and minimizing operational disruptions during active contracts"
      ],
      link: 'https://www.whatifsolutions.my/',
    ),
    Experience(
      title: 'Part-time Flutter Developer',
      company: 'My Day Thu Kywal',
      duration: 'Sep 2024 - Jan 2025',
      responsibilities: [
        "Delivered and maintained core mobile features for a social and live-streaming platform, supporting thousands of daily user interactions with stable performance",
        "Owned end-to-end implementation of engagement features (social interactions and live streaming), ensuring smooth user experience during peak usage periods",
        "Coordinated directly with Agora (third-party live streaming service provider) to clarify requirements, align technical flows, and reduce integration risks",
        "Optimized application performance and runtime behavior, reducing live-session interruptions and improving session stability",
        "Balanced part-time delivery commitments with production-quality standards, ensuring reliable releases and minimal post-deployment issues"
      ],
      link: 'https://myday.com.mm/',
    ),
    Experience(
      title: 'Flutter Developer',
      company: 'Kwin Technologies',
      duration: 'Sep 2022 - Apr 2025',
      responsibilities: [
        "Delivered end-to-end Flutter development across revenue-generating ecommerce, retail POS, clinic membership, and internal management applications, supporting multiple key client businesses simultaneously",
        "Translated business requirements from brand owners, clinic operators, shop owners, and management teams into scalable mobile workflows, reducing requirement clarification cycles and delivery delays",
        "Owned mobile-side architecture including UI/UX implementation, API integration, offline data handling, and real-time updates, ensuring full operational reliability in low-connectivity environments",
        "Improved development efficiency by introducing reusable UI components and structured state management, accelerating feature delivery across projects",
        "Ensured application stability and production readiness by collaborating closely with backend teams and proactively resolving logic and data consistency issues before release"
      ],
      link: 'http://kwintechnologies.com/',
    ),
  ];

  final List<EducationItem> _educationItems = const [
    EducationItem(
      degree: 'Bachelor of Science - BSc(Hons), Computing',
      university: 'University of Greenwich',
      duration: 'Dec 2024 - Nov 2025',
      linkUni: 'https://www.gre.ac.uk/',
      linkDegree: '',
    ),
    EducationItem(
      degree: 'Level-5 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Dec 2023 - Oct 2024',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/17Arr6LxB79z-KRWQOodM7-jT2C9dT1Md/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Level-4 Higher Diploma, Computing',
      university: 'NCC Education',
      duration: 'Jan 2023 - Dec 2023',
      linkUni: 'https://www.nccedu.com/',
      linkDegree:
          'https://drive.google.com/file/d/1JpU3znVEIstXyJopNBdGqJ8ysAgDo4jA/view?usp=sharing',
    ),
    EducationItem(
      degree: 'Final Part II - MBBS',
      university: 'University of Medicine 2, Yangon',
      duration: 'Dec 2014 - Jan 2020',
      linkUni: 'https://um2ygn.edu.mm/',
      linkDegree: '',
    ),
  ];

  final List<CertificationItem> _certificationItems = const [
    CertificationItem(
      icon: Icons.phone_android,
      name: 'Flutter Full Term Course(PADC)',
      link:
          'https://drive.google.com/file/d/1omIB7SXl7D_xmjbrkk-nEPDkfPuxvqD8/view?usp=sharing',
    ),
  ];

  final List<Project> _projects = const [
    Project(
      company: "Mya Satt Yaung Co., Ltd",
      images: [
        "assets/images/jade1.jpeg",
        "assets/images/jade2.jpeg",
        "assets/images/jade3.jpeg",
        "assets/images/jade4.jpeg",
        "assets/images/jade5.jpeg",
        "assets/images/jade6.jpeg",
      ],
      imagePath: 'assets/images/jademain.jpeg',
      title: 'Jade Property',
      description:
          'Highly Secured Real Estate Application with biometric authentications for managing properties, agents, clients, and transactions efficiently.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Collaborated with a senior mobile developer to implement required features, refine UI/UX, integrate backend APIs, and polish the application.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      // webLink: "https://admin.bluescreen.site/",
      webLink: "",
      status: "Not launched yet",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVC"},
        {"State Management": "GetX"},
        {"Backend": "PHP"},
      ],
      psAndKf: [
        "Property listing creation and management, enabling agents and administrators to add, update, and manage real estate assets.",
        "Automated property tax fee calculations based on property type, location, and transaction details.",
        "AI-powered chatbot providing instant assistance for property inquiries, pricing, and user support.",
        "Integrated payment processing for property create and advertisement fees.",
      ],
      challenges: [
        "Integrating OneSignal to deliver reliable real-time push notifications across iOS and Android platforms.",
        "Implementing Pusher for real-time in-app events and live data updates.",
        "Ensuring message delivery consistency and synchronization between push notifications and in-app states.",
        "Handling edge cases such as background, foreground, and terminated app states for real-time communication.",
      ],
    ),
    Project(
      company: "Whatif Solutions Sdn Bhd",
      status: "Live on Google Play/App Store",
      images: [
        "assets/images/digi_5.png",
        "assets/images/digi_1.png",
        "assets/images/digi_2.png",
        "assets/images/digi_3.png",
        "assets/images/digi_4.png",
      ],
      imagePath: 'assets/images/digicraft_main.png',
      title: 'Digicraft Home',
      description:
          'A smart home control app that connects users with their IoT devices, allowing them to monitor and manage appliances remotely.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer responsible for maintaining and refactoring legacy code, improving device connectivity reliability, and optimizing real-time control performance.',
      platform: "mobile",
      iosLink: "https://apps.apple.com/th/app/digicraft-home/id6443853027",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.whatif.mobile.homesecurity&pcampaignid=web_share",
      webLink: "",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVC"},
        {"State Management": "Flutx"},
        {"Backend": "MQTT broker"},
      ],
      psAndKf: [
        "Remote monitoring and control of smart appliances",
        "Real-time device status updates through MQTT",
        "Unified dashboard for managing multiple IoT devices",
        "Lightweight and efficient communication for low-power devices"
      ],
      challenges: [
        "Refactoring legacy Flutter codebase into a maintainable MVC structure",
        "Fixing critical bugs in device connectivity and real-time updates",
        "Ensuring smooth MQTT communication across different device types",
        "Improving UI consistency and responsiveness within Flutx framework"
      ],
    ),
    Project(
      status: "Live on Google Play/App Store",
      company: "Whatif Solutions Sdn Bhd",
      images: [
        "assets/images/zcul_1.png",
        "assets/images/zcul_2.png",
        "assets/images/zcul_3.png",
        "assets/images/zcul_4.png",
        "assets/images/zcul_5.png",
        "assets/images/zcul_6.png",
      ],
      imagePath: 'assets/images/zcultures_main.png',
      title: 'Zcultures',
      description:
          'A global AI-powered social commerce platform that leverages an O2O strategy to connect brands, creators, and nightlife venues for engagement.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer focused on legacy code refactoring, feature enhancements, performance optimization, and production bug fixes for live iOS and Android releases.',
      platform: "mobile",
      iosLink: "https://apps.apple.com/th/app/zcultures/id6747009373",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.zcultures.friends&pcampaignid=web_share",
      webLink: "",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVC"},
        {"State Management": "Flutx"},
        {"Backend": "PHP"},
      ],
      psAndKf: [
        "AI-powered recommendations for products, events, and venues",
        "Seamless O2O (Online-to-Offline) integration for social and commercial activities",
        "Interactive platform connecting brands, creators, and nightlife venues",
        "Personalized user experiences through smart data-driven features"
      ],
      challenges: [
        "Refactoring legacy Flutter codebase for improved maintainability",
        "Fixing UI inconsistencies and optimizing state management with Provider",
        "Resolving performance issues in real-time feed and recommendation rendering",
        "Enhancing app stability and scalability within the MVC + Flutx structure"
      ],
    ),
    Project(
      status: "Live on Google Play/App Store",
      company: "My Day Thu Kywal.co ltd",
      images: [
        "assets/images/weday_1.png",
        "assets/images/weday_2.png",
        "assets/images/weday_3.png",
        "assets/images/weday_4.png",
        "assets/images/weday_5.png",
      ],
      imagePath: 'assets/images/weday_main.png',
      title: 'Weday',
      description:
          'A social app with features for posts, comments, nested replies, reactions, and live streaming for online vendor live sales powered by Agora SDK.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer delivering core social features, integrating live-streaming services, and optimizing real-time interaction and streaming performance.',
      platform: "mobile",
      iosLink:
          "https://apps.apple.com/th/app/weday-social-commerce/id6743930076",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.markethub.businesscenter&pcampaignid=web_share",
      webLink: "",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Riverpod"},
        {"Backend": "Java"},
      ],
      psAndKf: [
        "Live streaming feature enabling vendors to sell products online in real-time",
        "Integrated comments with nested replies for structured discussions",
        "Reactions system to boost user engagement during posts and streams",
        "Seamless Agora SDK integration for stable and low-latency video streaming"
      ],
      challenges: [
        "Integrating and troubleshooting Agora SDK with Flutter for smooth streaming",
        "Designing scalable comments and nested replies structure for real-time interaction",
        "Managing complex state with Riverpod for dynamic social features",
        "Ensuring low-latency video and chat synchronization during live sales"
      ],
    ),
    Project(
      status: "Live on Google Play",
      company: "Kwin Technologies.co ltd",
      images: [
        "assets/images/suzuki_1.png",
        "assets/images/suzuki_2.png",
        "assets/images/suzuki_3.png",
        "assets/images/suzuki_4.png",
        "assets/images/suzuki_5.png",
      ],
      imagePath: 'assets/images/suzuki_main.png',
      title: 'Suzuki Smart Order',
      description:
          'An order management system developed for Suzuki, featuring product catalog, smart notifications, and Google Sign-In for easy access.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer and mobile team lead responsible for core framework development, API integrations, and real-time order notification workflows.',
      platform: "mobile",
      iosLink: "",
      androidLink:
          "https://play.google.com/store/apps/details?id=com.kwinhwl.suzuki_project&pcampaignid=web_share",
      webLink: "",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Provider"},
        {"Backend": "Node JS"},
      ],
      psAndKf: [
        "Streamlined product ordering with an intuitive mobile interface",
        "Smart notifications to keep dealers updated on order status",
        "Secure Google Sign-In for simplified authentication",
        "Real-time catalog browsing and stock availability"
      ],
      challenges: [
        "Ensuring seamless data synchronization between mobile app and backend",
        "Implementing MVVM architecture for scalable and maintainable code",
        "Integrating secure authentication with Google Sign-In",
        "Optimizing app performance for large product catalogs and multiple dealers"
      ],
    ),
    Project(
      company: "Kwin Technologies.co ltd",
      images: [
        "assets/images/arfi_1.png",
        "assets/images/arfi_2.png",
        "assets/images/arfi_3.png",
        "assets/images/arfi_4.png",
        "assets/images/arfi_5.png",
        "assets/images/arfi_6.png",
      ],
      imagePath: 'assets/images/arfi_main.png',
      title: 'ARFI Ecommerce',
      description:
          'E-commerce platform that enables brand owners to showcase products, manage customer orders, and handle online transactions seamlessly.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer responsible for building end-to-end ecommerce workflows, optimizing checkout performance, and implementing offline-ready state management.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      webLink: "",
      status: "Archive Project",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Provider"},
        {"Backend": "PHP"},
      ],
      psAndKf: [
        "Product catalog with categories and detailed product views",
        "Customer order management with real-time status updates",
        "Secure online payments and transaction handling",
        "Brand owner dashboard for managing inventory and sales"
      ],
      challenges: [
        "Designing a scalable MVVM architecture for maintainability",
        "Integrating secure payment gateways with backend Node.js APIs",
        "Managing real-time order updates between customers and brand owners",
        "Optimizing performance for large product catalogs with images"
      ],
    ),
    Project(
      company: "Kwin Technologies.co ltd",
      images: [
        "assets/images/wallet_1.png",
        "assets/images/wallet_2.png",
        "assets/images/wallet_3.png",
        "assets/images/wallet_4.png",
        "assets/images/wallet_5.png",
      ],
      imagePath: 'assets/images/dr_rej_main.png',
      title: 'Dr Rejvue Clinic Membership',
      description:
          'A membership management app for clinic patients to manage subscriptions, earn and redeem points, and access services with real-time updates.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer delivering membership, booking, and loyalty features with real-time synchronization and offline-first data handling.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      webLink: "",
      status: "Archive Project",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Provider"},
        {"Backend": "Node JS"},
      ],
      psAndKf: [
        "Subscription management for clinic patients with tier-based plans",
        "Loyalty points system to earn, track, and redeem rewards",
        "Real-time updates on membership status and clinic services",
        "Seamless integration with backend APIs for patient data and transactions"
      ],
      challenges: [
        "Implementing a flexible MVVM architecture for membership features",
        "Developing a secure and scalable points/rewards system",
        "Synchronizing patient membership data in real time with Node.js backend",
        "Optimizing performance while handling large patient data and transactions"
      ],
    ),
    Project(
      company: "Kwin Technologies.co ltd",
      images: [
        "assets/images/hrm_1.png",
        "assets/images/hrm_2.png",
        "assets/images/hrm_3.png",
        "assets/images/hrm_4.png",
        "assets/images/hrm_5.png",
      ],
      imagePath: 'assets/images/hrm_main.png',
      title: 'Kwin HR Management',
      description:
          'A complete HR solution providing employee management, leave requests, and performance tracking in one unified mobile platform.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Flutter Developer who independently designed and built the mobile application, delivering attendance tracking and payroll visibility features.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      webLink: "",
      status: "Internal use application",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Provider"},
        {"Backend": "Node JS"},
      ],
      psAndKf: [
        "Employee management with detailed profiles and role-based access",
        "Leave request and approval workflow with real-time notifications",
        "Performance tracking and evaluation tools for HR departments",
        "Seamless integration with backend APIs for centralized HR data"
      ],
      challenges: [
        "Designing scalable MVVM architecture for complex HR workflows",
        "Implementing secure role-based access for employees and HR managers",
        "Synchronizing employee data and leave requests in real time",
        "Optimizing performance with large datasets of employee records"
      ],
    ),
    Project(
      company: "Greenwich University",
      images: [
        "assets/images/sp1.png",
        "assets/images/sp2.png",
        "assets/images/sp3.png",
        "assets/images/sp4.png",
        "assets/images/sp5.png",
        "assets/images/sp6.png",
        "assets/images/sp7.png",
      ],
      imagePath: 'assets/images/sp1.png',
      title: 'SyncPro App',
      description:
          "A service management system for handling users, customers, warehouses, parts, service tests, reports, and approvals.",
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Individually handled the full software development lifecycle, including requirements analysis, UI/UX design, UML modeling, database structuring, backend API development, and complete Flutter frontend implementation.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      webLink: "https://youtu.be/rUdZglFv0a8",
      status: "University Project",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "MVP"},
        {"Backend": "PHP/Laravel"},
      ],
      psAndKf: [
        "Admin, engineer, and customer role-based dashboards",
        "User, customer, warehouse, and parts management",
        "Service test creation with parts usage tracking",
        "Test reporting, review, approval, and invoice generation"
      ],
      challenges: [
        "Implementing multi-role workflows with approval logic",
        "Managing dependencies between customers, buildings, and services",
        "Ensuring data consistency across tests, parts, and reports",
        "Designing clear status transitions from pending to approved"
      ],
    ),
    Project(
      company: "Greenwich University",
      images: [
        "assets/images/hiker1.png",
        "assets/images/hiker2.png",
        "assets/images/hiker3.png",
        "assets/images/hiker4.png",
        "assets/images/hiker5.png",
        "assets/images/hiker6.png",
        "assets/images/hiker7.png",
        "assets/images/hiker8.png",
        "assets/images/hiker9.png",
        "assets/images/hiker10.png",
      ],
      imagePath: 'assets/images/hikerpp.png',
      title: 'Hiker(native/hybrid)',
      description:
          "A hiking management app for creating, tracking, and managing hikes with observations, search, and data reset features.",
      techIcons: FontAwesomeIcons.mobile,
      role:
          'Frontend Developer responsible for UI design, feature implementation, testing, and APK export for both native and hybrid versions of the application.',
      platform: "mobile",
      iosLink: "",
      androidLink: "",
      webLink: "https://youtu.be/rUdZglFv0a8",
      status: "University Project",
      techStacks: [
        {"Framework/Language": "Kotlin/React Native"},
        {"Architecture": "MVVM"},
        {"State Management": "Nil"},
        {"Backend": "Nil"},
      ],
      psAndKf: [
        "Create, edit, delete, and manage hiking adventures",
        "Observation tracking for each hike",
        "Search and filter hikes by name and location",
        "Local data storage with reset and refresh options"
      ],
      challenges: [
        "Designing flexible data models for hikes and observations",
        "Implementing efficient search and filtering logic",
        "Managing local data persistence and reset operations",
        "Maintaining feature parity between native and hybrid versions"
      ],
    ),
    Project(
      company: "Greenwich University",
      images: [
        "assets/images/ewsd1.png",
        "assets/images/ewsd2.png",
        "assets/images/ewsd3.png",
        "assets/images/ewsd4.png",
        "assets/images/ewsd5.png",
        "assets/images/ewsd6.png",
        "assets/images/ewsd7.png",
        "assets/images/ewsd8.png",
        "assets/images/ewsd9.png",
        "assets/images/ewsd10.png",
        "assets/images/ewsd11.png",
      ],
      imagePath: 'assets/images/ewsd1.png',
      title: 'Article Contribution',
      description:
          'A system for managing academic article submissions with role-based access for students, faculty coordinators, admins, and marketing managers.',
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Frontend Developer responsible for UI design, feature implementation, API integration, and project deployment using Flutter for web.',
      platform: "web",
      iosLink: "",
      androidLink: "",
      webLink: "https://www.youtube.com/watch?v=VE5D7_2tWiA",
      status: "University Project",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Get X"},
        {"Backend": "PHP"},
      ],
      psAndKf: [
        "Role-based academic article submission and management system",
        "Student article upload with document and image support",
        "Faculty review, commenting, approval, and publication workflow",
        "Automated email notifications and submission deadline management"
      ],
      challenges: [
        "Implementing secure role-based access for multiple user types",
        "Designing scalable workflows for submission, review, and approval",
        "Handling document uploads, previews, and resubmissions",
        "Ensuring reliable email notifications and status synchronization"
      ],
    ),
    Project(
      company: "Greenwich University",
      images: [
        "assets/images/sdm1.png",
        "assets/images/sdm2.png",
        "assets/images/sdm3.png",
        "assets/images/sdm4.png",
        "assets/images/sdm5.png",
        "assets/images/sdm6.png",
        "assets/images/sdm7.png",
      ],
      imagePath: 'assets/images/sdm1.png',
      title: 'Shady Momentum',
      description:
          "A two-panel gym management system where admins manage users, classes, memberships, and payments, and clients book programs and classes.",
      techIcons: FontAwesomeIcons.flutter,
      role:
          'Frontend Developer responsible for designing user interfaces, implementing role-based features, integrating backend APIs, and deploying the web application.',
      platform: "web",
      iosLink: "",
      androidLink: "",
      webLink: "https://youtu.be/rUdZglFv0a8",
      status: "University Project",
      techStacks: [
        {"Framework/Language": "Flutter/Dart"},
        {"Architecture": "MVVM"},
        {"State Management": "Get X"},
        {"Backend": "PHP"},
      ],
      psAndKf: [
        "Admin and client dashboards with role-based access",
        "User, class, membership, and payment management",
        "Class and program booking system for clients",
        "Membership tracking and payment status management"
      ],
      challenges: [
        "Designing clear separation between admin and client panels",
        "Implementing secure role-based authentication and authorization",
        "Managing real-time class availability and booking conflicts",
        "Structuring scalable data models for memberships and payments"
      ],
    ),

    // Project(
    //   company: "Whatif Solutions Sdn Bhd",
    //   images: [
    //     "assets/images/tiger_1.png",
    //     "assets/images/tiger_2.png",
    //     "assets/images/tiger_3.png",
    //     "assets/images/tiger_4.png",
    //     "assets/images/tiger_5.png",
    //   ],
    //   imagePath: 'assets/images/tiger_main.png',
    //   title: 'Tiger Backoffice',
    //   description:
    //       'A backoffice management system for online casinos, providing modules for banking, transactions, user settings, and log tracking.',
    //   techIcons: FontAwesomeIcons.laravel,
    //   role:
    //       'Develop full stack dashboard together under a lead senior fullstack developer',
    //   platform: "web",
    //   iosLink: "",
    //   androidLink: "",
    //   // webLink: "https://admin.bluescreen.site/",
    //   webLink: "",
    //   status: "Internal use application",
    //   techStacks: [
    //     {"Framework/Language": "Laravel/PHP"},
    //     {"Architecture": "MVVM"},
    //     {"State Management": "Controller"},
    //     {"Backend": "PostGraphQl"},
    //   ],
    //   psAndKf: [
    //     "Centralized management of financial transactions and user accounts for online casinos.",
    //     "Streamlined admin workflows by providing all modules in a single dashboard.",
    //     "User account management including roles, permissions, and settings.",
    //     "Detailed log tracking and activity monitoring for security compliance.",
    //     "Modular dashboard design for easy navigation between different backoffice sections."
    //   ],
    //   challenges: [
    //     "Integrating multiple financial APIs securely and efficiently.",
    //     "Ensuring real-time updates for transactions and banking data.",
    //     "Maintaining high security and access control for sensitive casino data.",
    //     "Coordinating development with a team under tight project deadlines."
    //   ],
    // ),
    // Project(
    //   company: "Whatif Solutions Sdn Bhd",
    //   images: [
    //     "assets/images/infinity_1.png",
    //     "assets/images/infinity_2.png",
    //     "assets/images/infinity_3.png",
    //     "assets/images/infinity_4.png",
    //     "assets/images/infinity_5.png",
    //     "assets/images/infinity_6.png",
    //   ],
    //   imagePath: 'assets/images/infinity_main.jpg',
    //   title: 'Infinity 688 Backoffice',
    //   description:
    //       'A backoffice solution for casino operators, designed for secure transaction handling, banking integration, and operational monitoring.',
    //   techIcons: FontAwesomeIcons.laravel,
    //   role:
    //       'Develop full stack dashboard together under a lead senior fullstack developer',
    //   platform: "web",
    //   iosLink: "",
    //   androidLink: "",
    //   webLink: "",
    //   status: "Internal use application",
    //   // webLink: "https://mmk.infinitynow.biz/login",
    //   techStacks: [
    //     {"Framework/Language": "Laravel/PHP"},
    //     {"Architecture": "MVVM"},
    //     {"State Management": "Controller"},
    //     {"Backend": "PostGraphQl"},
    //   ],
    //   psAndKf: [
    //     "Centralized management of financial transactions and user accounts for online casinos.",
    //     "Streamlined admin workflows by providing all modules in a single dashboard.",
    //     "User account management including roles, permissions, and settings.",
    //     "Detailed log tracking and activity monitoring for security compliance.",
    //     "Modular dashboard design for easy navigation between different backoffice sections."
    //   ],
    //   challenges: [
    //     "Integrating multiple financial APIs securely and efficiently.",
    //     "Ensuring real-time updates for transactions and banking data.",
    //     "Maintaining high security and access control for sensitive casino data.",
    //     "Coordinating development with a team under tight project deadlines."
    //   ],
    // ),
  ];

  bool _isProfilePrecached = false;
  bool _typewriterDone = false;
  bool _isSending = false;
  PageController? _projectsPageController;
  int _currentProjectIndex = 0;
  @override
  void initState() {
    super.initState();

    // Initialize main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Initialize section animation controllers
    _experiencesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _educationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _projectsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _contactController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Add scroll listener to show/hide back to top button and trigger section animations
    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        if (!_showBackToTop) {
          setState(() {
            _showBackToTop = true;
          });
        }
      } else {
        if (_showBackToTop) {
          setState(() {
            _showBackToTop = false;
          });
        }
      }

      _triggerSectionAnimations();
    });

    // Section animations
    _experiencesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _experiencesController, curve: Curves.easeInOut));
    _educationFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _educationController, curve: Curves.easeInOut));
    _projectsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _projectsController, curve: Curves.easeInOut));
    _contactFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _contactController, curve: Curves.easeInOut));

    _mainController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheProfileImage();
    });

    _projectsPageController = PageController(viewportFraction: 0.85);
  }

  Future<void> _precacheProfileImage() async {
    const imagePath = "assets/images/me_profile.png";
    await precacheImage(const AssetImage(imagePath), context);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isProfilePrecached = true;
      });
    }
  }

  // Method to trigger section animations based on scroll position
  void _triggerSectionAnimations() {
    final scrollOffset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    // Trigger experiences animation when section comes into view
    if (scrollOffset > screenHeight * 0.3 &&
        !_experiencesController.isCompleted) {
      _experiencesController.forward();
    }

    // Trigger education animation when section comes into view
    if (scrollOffset > screenHeight * 0.8 &&
        !_educationController.isCompleted) {
      _educationController.forward();
    }

    // Trigger projects animation when section comes into view
    if (scrollOffset > screenHeight * 1.5 && !_projectsController.isCompleted) {
      _projectsController.forward();
    }

    // Trigger contact animation when section comes into view
    if (scrollOffset > screenHeight * 2.2 && !_contactController.isCompleted) {
      _contactController.forward();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _experiencesController.dispose();
    _educationController.dispose();
    _projectsController.dispose();
    _contactController.dispose();
    _projectsPageController?.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Method to scroll to specific section
  void _scrollToSection(String section) {
    GlobalKey? targetKey;

    switch (section) {
      case 'Experiences':
        targetKey = _experiencesKey;
        break;
      case 'Education':
        targetKey = _educationKey;
        break;
      case 'Projects':
        targetKey = _projectsKey;
        break;
      case 'Contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll to show the section near the top
      );
    }
  }

  // Method to scroll to top
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color(0xFFEA3799),
              size: 100,
            ),
          );
        },
      );

      try {
        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        const serviceId = 'service_dx6jkwf';
        const templateId = 'template_dsbktpk';
        const userId = 'nEOpcklJoxm-lX5As';

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Origin': 'https://htetwai18.github.io',
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'public_key': userId,
            'template_params': {
              'title': 'Portfolio Contact',
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'message': _messageController.text.trim(),
            }
          }),
        );

        // final response = await http.post(
        //   url,
        //   headers: {
        //     'Content-Type': 'application/json',
        //   },
        //   body: json.encode({
        //     'service_id': serviceId,
        //     'template_id': templateId,
        //     'user_id': userId,
        //     'template_params': {
        //       'name': _nameController.text,
        //       'email': _emailController.text,
        //       'message': _messageController.text,
        //     }
        //   }),
        // );

        Navigator.of(context, rootNavigator: true).pop();

        if (response.statusCode == 200) {
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to send message. (${response.statusCode}) Please try again.'),
            ),
          );
        }
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred. Please try again later.')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      }
    }
  }

  // void _downloadResume() {
  //   final uri = Uri.parse(
  //     '${Uri.base.origin}${Uri.base.path}assets/resume/Htet_Wai_Lwin_Resume.pdf',
  //   );
  //
  //   html.AnchorElement(href: uri.toString())
  //     ..setAttribute('download', 'Htet_Wai_Lwin_Resume.pdf')
  //     ..click();
  // }

  Future<void> _downloadResume() async {
    final Uri uri = Uri.parse(
        'https://drive.google.com/file/d/1BJt7LL-Qt4YgSnedOmzWu-OhozmDbg8a/view?usp=sharing');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Cannot launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;

    return (!_isProfilePrecached)
        ? Container(
            color: const Color.fromRGBO(1, 0, 0, 1),
            child: Center(
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 120,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromRGBO(1, 0, 0, 1),
            appBar: (!isDesktop)
                ? AppBar(
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(1, 0, 0, 1),
                    iconTheme: const IconThemeData(color: Colors.white),
                  )
                : null,
            drawer: (!isDesktop)
                ? Drawer(
                    elevation: 0,
                    width: 160,
                    backgroundColor: const Color.fromRGBO(1, 0, 0, 1),
                    child: SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: [
                          ListTile(
                            title: Text('Home',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _scrollToTop();
                            },
                          ),
                          ListTile(
                            title: Text('Projects',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _scrollToSection('Projects');
                            },
                          ),
                          ListTile(
                            title: Text('Experiences',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _scrollToSection('Experiences');
                            },
                          ),
                          ListTile(
                            title: Text('Education',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _scrollToSection('Education');
                            },
                          ),
                          ListTile(
                            title: Text('Contact',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _scrollToSection('Contact');
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            floatingActionButton: _showBackToTop
                ? FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor: const Color(0xFFBB86FC),
                    foregroundColor: const Color(0xFF121212),
                    elevation: 8,
                    child: const Icon(Icons.keyboard_arrow_up, size: 28),
                  )
                : null,
            body: Container(
              // --- FIX #1: REMOVE PINK/PURPLE TINT FROM GRADIENT ---
              // Replaced the previous colors with a cleaner, more neutral gradient.
              decoration: const BoxDecoration(
                color: Color.fromRGBO(1, 0, 0, 1),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isDesktop)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 40, right: 60),
                          height: 50,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              NavLink(
                                  title: 'Projects',
                                  page: widget.page,
                                  onSectionClick: _scrollToSection),
                              NavLink(
                                  title: 'Experiences',
                                  page: widget.page,
                                  onSectionClick: _scrollToSection),
                              NavLink(
                                  title: 'Education',
                                  page: widget.page,
                                  onSectionClick: _scrollToSection),
                              NavLink(
                                  title: 'Contact',
                                  page: widget.page,
                                  onSectionClick: _scrollToSection),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 120 : 20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: isDesktop ? double.infinity : 900),
                        child: Flex(
                          direction:
                              isDesktop ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- Left Section: Text and Buttons ---
                            Flexible(
                              flex: isDesktop ? 2 : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: isDesktop
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Hello, welcome...',
                                    style: GoogleFonts.oxanium(
                                      fontSize: isDesktop ? 23 : 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    textAlign: isDesktop
                                        ? TextAlign.start
                                        : TextAlign.center,
                                  ),
                                  Text(
                                    'I am Htet Wai Lwin',
                                    style: GoogleFonts.oxanium(
                                      fontSize: isDesktop ? 55 : 34,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFBB86FC),
                                    ),
                                    textAlign: isDesktop
                                        ? TextAlign.start
                                        : TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        'Mobile Application Developer(Flutter)',
                                        textStyle: GoogleFonts.oxanium(
                                          fontSize: isDesktop ? 32 : 18,
                                          color: Colors.white,
                                        ),
                                        speed:
                                            const Duration(milliseconds: 100),
                                        textAlign: isDesktop
                                            ? TextAlign.start
                                            : TextAlign.center,
                                      ),
                                    ],
                                    totalRepeatCount: 1,
                                    pause: const Duration(milliseconds: 500),
                                    displayFullTextOnTap: true,
                                    onFinished: () {
                                      if (mounted) {
                                        setState(() {
                                          _typewriterDone = true;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Building cross-platform apps with Flutter & Dart.',
                                    style: GoogleFonts.poppins(
                                      fontSize: isDesktop ? 20 : 14,
                                      color: Colors.grey[400],
                                    ),
                                    textAlign: isDesktop
                                        ? TextAlign.start
                                        : TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    "I'm a passionate Mobile developer with a focus on creating beautiful and functional cross-platform applications. I have over 3 years of experience in mobile app development, specializing in Flutter and Dart.",
                                    style: GoogleFonts.poppins(
                                      fontSize: isDesktop ? 16 : 12,
                                      color: Colors.white,
                                    ),
                                    textAlign: isDesktop
                                        ? TextAlign.start
                                        : TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        color: Color(0xFFBB86FC),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "htetwai.18.lwin@gmail.com",
                                        style: GoogleFonts.oxanium(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Color(0xFFBB86FC),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "+66 917073034",
                                        style: GoogleFonts.oxanium(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFBB86FC),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Bangkok",
                                        style: GoogleFonts.oxanium(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _downloadResume();
                                    },
                                    icon: const Icon(Icons.download),
                                    label: Text(
                                      'Download Resume',
                                      style: GoogleFonts.oxanium(fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBB86FC),
                                      foregroundColor: const Color(0xFF121212),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      elevation: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    'My Skills',
                                    style: GoogleFonts.oxanium(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  buildSkillsWrap(isDesktop),
                                ],
                              ),
                            ),

                            if (isDesktop) const SizedBox(width: 80),
                            if (!isDesktop) const SizedBox(height: 40),

                            // --- Right Section: Profile Picture ---
                            Flexible(
                              flex: isDesktop ? 2 : 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                opacity:
                                    (_typewriterDone && _isProfilePrecached)
                                        ? 1.0
                                        : 0.0,
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeOutBack,
                                  scale:
                                      (_typewriterDone && _isProfilePrecached)
                                          ? 1.0
                                          : 0.85,
                                  child: Container(
                                    width: isDesktop ? 380 : 200,
                                    height: isDesktop ? 380 : 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF1E1E1E),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            blurRadius: 40,
                                            offset: const Offset(0, 15))
                                      ],
                                      border: Border.all(
                                          color: const Color(0xFFBB86FC)
                                              .withOpacity(0.3),
                                          width: 6),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/me_profile.png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(Icons.person, size: 100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    // Home section
                    Container(
                      key: _experiencesKey,
                      child: _buildHeader(),
                    ),
                    const SizedBox(height: 48),
                    FadeTransition(
                      opacity: _experiencesFadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _experiencesController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: _buildTimeline(),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Container(
                      key: _educationKey,
                      child: _buildSectionHeader('Education'),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _educationFadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _educationController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: _buildEducationTimeline(),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Certifications'),
                    const SizedBox(height: 24),
                    _buildCertificationsGrid(),
                    const SizedBox(height: 100),
                    // Projects section
                    Container(
                      key: _projectsKey,
                      child: _buildProjectHeader(),
                    ),
                    const SizedBox(height: 48),
                    FadeTransition(
                      opacity: _projectsFadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _projectsController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildProjectsGrid(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Contact section
                    Container(
                      key: _contactKey,
                      child: _buildContactHeader(context),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _contactFadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _contactController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Column(
                          children: [
                            _buildFormCard(context),
                            const SizedBox(height: 48),
                            _buildContactFooter(context),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildSkillsWrap(bool isLargeScreen) {
    final List<String> skills = [
      'Flutter',
      'Dart',
      'Firebase',
      'REST API',
      'Provider',
      'Riverpod',
      'Bloc',
      'GetX',
      'Git',
      'Laravel',
      'SQL'
    ];
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      alignment: isLargeScreen ? WrapAlignment.start : WrapAlignment.center,
      children: skills.map((skill) => buildSkillChip(skill)).toList(),
    );
  }

  Widget buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: GoogleFonts.oxanium(
          color: const Color(0xFFBB86FC),
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: const Color(0xFFBB86FC).withOpacity(0.3)),
      ),
    );
  }

  Widget buildQuickStatsSection(bool isLargeScreen) {
    final List<Map<String, String>> stats = [
      {'value': '3+', 'label': 'Years Experience'},
      {'value': '8+', 'label': 'Projects Completed'},
    ];

    if (!isLargeScreen) {
      return Column(
        children: stats
            .map((stat) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: buildStatCard(stat)))
            .toList(),
      );
    } else {
      return Row(
        children: stats
            .map((stat) => Expanded(
                child: buildStatCard(stat,
                    margin: const EdgeInsets.only(right: 16.0))))
            .toList(),
      );
    }
  }

  Widget buildStatCard(Map<String, String> stat, {EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade700)),
      child: Column(
        children: [
          Text(stat['value']!,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: const Color(0xFFBB86FC))),
          const SizedBox(height: 8),
          Text(stat['label']!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[400]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.oxanium(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            children: const [
              TextSpan(text: 'My Professional '),
              TextSpan(
                text: 'Experience',
                style: TextStyle(color: Color(0xFFBB86FC)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A timeline of my journey as a Flutter Developer, contributing to innovative mobile applications.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a single-column layout on narrow screens
        bool isNarrow = constraints.maxWidth < 760;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: (isNarrow) ? 14 : 100),
          child: Column(
            children: List.generate(_experiences.length, (index) {
              final experience = _experiences[index];
              final isFirst = index == 0;
              final isLast = index == _experiences.length - 1;
              // On wide screens, alternate alignment. On narrow, all are right-aligned.
              final isLeftAligned = !isNarrow && index % 2 == 1;

              return AnimatedTimelineTile(
                experience: experience,
                isFirst: isFirst,
                isLast: isLast,
                isLeftAligned: isLeftAligned,
                isNarrow: isNarrow,
                animationController: _experiencesController,
                delay:
                    Duration(milliseconds: index * 200), // Staggered animation
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.oxanium(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFBB86FC),
      ),
    );
  }

  Widget _buildEducationTimeline() {
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Cannot launch url";
      }
    }

    return Column(
      children: List.generate(_educationItems.length, (index) {
        // Alternate between left and right alignment for zigzag effect
        final isLeftAligned = index % 2 == 1;

        return AnimatedEducationTile(
          onTapLinkDegree: () async {
            // Todo: will open later
            // if (_educationItems[index].linkDegree != '') {
            //   await _launchUrl(_educationItems[index].linkDegree);
            // }
          },
          item: _educationItems[index],
          isFirst: index == 0,
          isLast: index == _educationItems.length - 1,
          isLeftAligned: isLeftAligned,
          animationController: _educationController,
          delay: Duration(milliseconds: index * 200), // Staggered animation
          onTapLinkUni: () async {
            await _launchUrl(_educationItems[index].linkUni);
          },
        );
      }),
    );
  }

  Widget _buildCertificationsGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _certificationItems
          .map(
            (item) => CertificationCard(item: item),
          )
          .toList(),
    );
  }

  Widget _buildProjectHeader() {
    return Column(
      children: [
        Text(
          'My Projects',
          style: GoogleFonts.oxanium(
            fontSize: 42,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A selection of my recent work, showcasing my skills and experience in software development.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsGrid() {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;

    if (isDesktop) {
      return Wrap(
        spacing: 34,
        runSpacing: 0,
        alignment: WrapAlignment.center,
        children:
            _projects.map((project) => ProjectCard(project: project)).toList(),
      );
    }

    // Mobile: horizontal pager with indicator
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _projectsPageController,
            itemCount: _projects.length,
            onPageChanged: (index) {
              setState(() {
                _currentProjectIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ProjectCard(project: _projects[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_projects.length, (i) {
            final bool isActive = i == _currentProjectIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFBB86FC)
                    : const Color(0xFFBB86FC).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          '${_currentProjectIndex + 1} / ${_projects.length}',
          style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildContactHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Get in Touch',
          style: GoogleFonts.oxanium(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities.\nFeel free to reach out, and I'll get back to you as soon as possible.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;
    return Container(
      width: isDesktop ? (screenSize.width) / 2 : null,
      margin: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 0)
          : const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use LayoutBuilder for responsive Name/Email fields
            LayoutBuilder(
              builder: (context, constraints) {
                // Use a breakpoint to switch between Row and Column
                if (constraints.maxWidth > 550) {
                  return Row(
                    children: [
                      Expanded(
                          child: _buildTextFormField('Your Name',
                              controller: _nameController)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextFormField('Your Email',
                              controller: _emailController)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTextFormField('Your Name',
                          controller: _nameController),
                      const SizedBox(height: 16),
                      _buildTextFormField('Your Email',
                          controller: _emailController),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField('Your Message',
                maxLines: 5, controller: _messageController),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSending ? null : _sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: const Color(0xFF121212),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                shadowColor: Colors.indigo.withOpacity(0.4),
              ),
              child: Text(
                'Send Message',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label,
      {int maxLines = 1, required TextEditingController controller}) {
    return TextFormField(
      controller: controller, // Assign the controller
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFBB86FC), width: 2),
        ),
      ),
      style: GoogleFonts.poppins(
        color: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Your Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildContactFooter(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;

    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Cannot launch url";
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 40),
                child: SizedBox(
                  height: 30,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(FontAwesomeIcons.github, () async {
                        await _launchUrl('https://github.com/htetwai18');
                      }, 'Github'),
                      const SizedBox(width: 24),
                      _buildSocialIcon(FontAwesomeIcons.linkedin, () async {
                        await _launchUrl(
                            'https://www.linkedin.com/in/htetwailwin/');
                      }, 'LinkedIn'),
                      const SizedBox(width: 24),
                      _buildSocialIcon(
                          FontAwesomeIcons
                              .whatsapp, // Phone is available in default Material Icons
                          () async {
                        await _launchUrl(
                            'https://wa.me/+660917073034'); // opens phone dialer
                      }, 'Whatsapp'),
                      const SizedBox(width: 24),
                      _buildSocialIcon(
                          FontAwesomeIcons
                              .line, // Phone is available in default Material Icons
                          () async {
                        await _launchUrl(
                            'https://line.me/ti/p/_uU9xGhxNP'); // opens phone dialer
                      }, 'Line'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© 2025 Htet Wai Lwin. Created with Flutter 3.35.4',
            style: GoogleFonts.oxanium(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Function onTap, String tip) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey[400]),
      onPressed: () {
        onTap();
      },
      splashRadius: 24,
      tooltip: tip,
    );
  }
}

// Animated Timeline Tile for branching effect
class AnimatedTimelineTile extends StatefulWidget {
  final Experience experience;
  final bool isFirst;
  final bool isLast;
  final bool isLeftAligned;
  final bool isNarrow;
  final AnimationController animationController;
  final Duration delay;

  const AnimatedTimelineTile({
    super.key,
    required this.experience,
    required this.isFirst,
    required this.isLast,
    required this.isLeftAligned,
    required this.isNarrow,
    required this.animationController,
    required this.delay,
  });

  @override
  State<AnimatedTimelineTile> createState() => _AnimatedTimelineTileState();
}

class _AnimatedTimelineTileState extends State<AnimatedTimelineTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _itemController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _itemController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _itemController, curve: Curves.easeInOut),
    );

    // Create branching effect - items slide in from periphery toward center
    final slideBegin = widget.isLeftAligned
        ? const Offset(-0.5, 0) // From left
        : const Offset(0.5, 0); // From right

    _slideAnimation =
        Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(
      CurvedAnimation(parent: _itemController, curve: Curves.easeOutCubic),
    );

    // Start animation with delay when parent controller starts
    widget.animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _itemController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: TimelineTile(
          experience: widget.experience,
          isFirst: widget.isFirst,
          isLast: widget.isLast,
          isLeftAligned: widget.isLeftAligned,
          isNarrow: widget.isNarrow,
        ),
      ),
    );
  }
}

// Animated Education Tile for branching effect
class AnimatedEducationTile extends StatefulWidget {
  final EducationItem item;
  final bool isFirst;
  final bool isLast;
  final bool isLeftAligned;
  final Function onTapLinkUni, onTapLinkDegree;
  final AnimationController animationController;
  final Duration delay;

  const AnimatedEducationTile({
    super.key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.isLeftAligned,
    required this.onTapLinkUni,
    required this.onTapLinkDegree,
    required this.animationController,
    required this.delay,
  });

  @override
  State<AnimatedEducationTile> createState() => _AnimatedEducationTileState();
}

class _AnimatedEducationTileState extends State<AnimatedEducationTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _itemController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _itemController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _itemController, curve: Curves.easeInOut),
    );

    // Create branching effect - items slide in from periphery toward center
    final slideBegin = widget.isLeftAligned
        ? const Offset(-0.5, 0) // From left
        : const Offset(0.5, 0); // From right

    _slideAnimation =
        Tween<Offset>(begin: slideBegin, end: Offset.zero).animate(
      CurvedAnimation(parent: _itemController, curve: Curves.easeOutCubic),
    );

    // Start animation with delay when parent controller starts
    widget.animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _itemController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: EducationTile(
          onTapLinkDegree: widget.onTapLinkDegree,
          item: widget.item,
          isFirst: widget.isFirst,
          isLast: widget.isLast,
          isLeftAligned: widget.isLeftAligned,
          onTapLinkUni: widget.onTapLinkUni,
        ),
      ),
    );
  }
}
