// new module header
#define MAX_POINTS 32
#define MAX_ARBITERS 16
#define MAX_BODIES 256
#define MAX_JOINTS 256
#define MAX_CONTACTS 256

managed struct Vec2
{
	float x, y;

  import static Vec2* New(float x, float y);
 	import void Set(float x, float y);
  import Vec2* Negate();
	import Vec2* Minus(Vec2* vb);
  import Vec2* Plus(Vec2* vb);
  import Vec2* Scale(float a);
  import float Length();
  import float Dot(const Vec2* b);
  import float Cross(const Vec2* b);
};

managed struct Mat22
{
  float col1_x, col1_y, col2_x, col2_y;
  
  import static Mat22* New(float col1_x, float col1_y, float col2_x, float col2_y);
  import static Mat22* NewFromAngle(float angle);
  import static Mat22* NewFromVec2(Vec2* col1, Vec2* col2);
  import Mat22* Transpose();
  import Mat22* Invert();
  import Mat22* Plus(const Mat22* B);
  import Mat22* Multiply(const Mat22* B);
};

managed struct Body
{  
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
  
	import void Set(Body* body1, Body* body2, const Vec2* anchor);

	import void PreStep(float inv_dt);
	import void ApplyImpulse();
};

managed struct FeaturePair
{
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
};

managed struct ArbiterKey
{
	Body* body1;
	Body* body2;
};

managed struct Arbiter
{
  static import Arbiter* Create(Body* b1, Body* b2);
  
  import void Update(Contact* contacts[],  int numContacts);
  
	import void PreStep(float inv_dt);
	import void ApplyImpulse();

	Contact* contacts[MAX_POINTS];
	int numContacts;

	Body* body1;
	Body* body2;

	// Combined friction
	float friction;
};



managed struct Arbiters
{
  ArbiterKey* key;
  Arbiter* value;  
};

struct World
{
	import void AddBody(Body* body);
	import void AddJoint(Joint* joint);
	import void Clear();

	import void Step(float dt);

	import void BroadPhase();

	Body* bodies[MAX_BODIES];
	Joint* joints[MAX_JOINTS];
	Arbiters* arbiters[MAX_ARBITERS];
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