// new module header
#define MAX_POINTS 32
#define MAX_ARBITERS 16
#define MAX_BODIES 256
#define MAX_JOINTS 256
#define MAX_CONTACTS 256

managed struct Vec2
{
	float x, y;

  import static Vec2* New(float x, float y); // $AUTOCOMPLETESTATICONLY$
 	import void Set(float x, float y);
  import Vec2* Abs();
  import Vec2* Negate();
	import Vec2* Minus(Vec2* vb);
  import Vec2* Plus(Vec2* vb);
  import Vec2* Scale(float a);
  import float Length();
  import float Dot(Vec2* b);
  import float Cross(Vec2* b);
};

managed struct Mat22
{
  float col1_x, col1_y, col2_x, col2_y;
  
  import static Mat22* New(float col1_x, float col1_y, float col2_x, float col2_y); // $AUTOCOMPLETESTATICONLY$
  import static Mat22* NewFromAngle(float angle); // $AUTOCOMPLETESTATICONLY$
  import static Mat22* NewFromVec2(Vec2* col1, Vec2* col2); // $AUTOCOMPLETESTATICONLY$
  import Mat22* Transpose();
  import Mat22* Invert();
  import Mat22* Plus(Mat22* B);
  import Mat22* Multiply(Mat22* B);
  import Mat22* Abs();
};

managed struct Body
{
  import static Body* Create();
	float position_x, position_y;
	float rotation;

	float velocity_x, velocity_y;
	float angularVelocity;

	float force_x, force_y;
	float torque;

	float width_x, width_y;

	float friction;
	float mass, invMass;
	float I, invI;
    
	import void Set(Vec2* w, float m);
	import void AddForce(const Vec2* f);
};

managed struct Joint
{
	Mat22* M;
	Vec2* localAnchor1, localAnchor2;
	Vec2* r1, r2;
	Vec2* bias;
	Vec2* P;		// accumulated impulse
	Body* body1;
	Body* body2;
	float biasFactor;
	float softness;
  
	import void Set(Body* body1, Body* body2, Vec2* anchor);

	import void PreStep(float inv_dt);
	import void ApplyImpulse();
};

managed struct FeaturePair
{
  static import FeaturePair* Create();
  
  char inEdge1;
  char outEdge1;
  char inEdge2;
  char outEdge2;
  import attribute int value;
  import int get_value();
  import void set_value(int value);
};

managed struct Contact
{
	Vec2* position;
	Vec2* normal;
	Vec2* r1, r2;
	float separation;
	float Pn;	// accumulated normal impulse
	float Pt;	// accumulated tangent impulse
	float Pnb;	// accumulated normal impulse for position bias
	float massNormal, massTangent;
	float bias;
	FeaturePair* feature;
  import void CopyTo(Contact* c);
};

managed struct Arbiter
{
  static import Arbiter* Create(Body* b1, Body* b2);
  
  import void Update(Contact* contacts[],  int numContacts);
  
	import void PreStep(float inv_dt);
	import void ApplyImpulse();

	Contact* contacts[];
	int numContacts;

	Body* body1;
	Body* body2;

	// Combined friction
	float friction;
};

managed struct Arbiters
{
  import void Add(Arbiter* arb);
  import void Remove(Body* b1, Body* b2);
  import Arbiter* Get(Body* b1, Body* b2);
  import void Clear();
  
  Arbiter* a[MAX_ARBITERS];
  int a_count;
};

struct World
{
	import void AddBody(Body* body);
	import void AddJoint(Joint* joint);
	import void Clear();

	import void Step(float dt);

	import void BroadPhase();

	Body* bodies[MAX_BODIES];
	int body_count;
  Joint* joints[MAX_JOINTS];
  int joint_count;
	Arbiters* arbiters;
  
	Vec2* gravity;
	int iterations;
	static import attribute bool accumulateImpulses;
  static import bool get_accumulateImpulses();
  static import void set_accumulateImpulses(bool value);
	static import attribute bool warmStarting;
  static import bool get_warmStarting();
  static import void set_warmStarting(bool value);
	static import attribute bool positionCorrection;
  static import bool get_positionCorrection();
  static import void set_positionCorrection(bool value);
};