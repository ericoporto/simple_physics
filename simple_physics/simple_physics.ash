// new module header
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
    
	import void Set(const Vec2* w, float m);
	import void AddForce(const Vec2* f);
};

struct Joint
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
	int value;
};

struct Contact
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

struct ArbiterKey
{
	Body* body1;
	Body* body2;
};

struct Arbiter
{
	import void PreStep(float inv_dt);
	import void ApplyImpulse();

	//Contact contacts[MAX_POINTS];
	int numContacts;

	Body* body1;
	Body* body2;

	// Combined friction
	float friction;
};