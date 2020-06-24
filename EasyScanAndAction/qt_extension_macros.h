#ifndef QT_EXTENSION_MACROS_H
#define QT_EXTENSION_MACROS_H


#define JWPROPERTY(type, name, uppercasename, defaultvalue) \
private: \
type m_##name = {defaultvalue}; \
public: \
Q_PROPERTY(type name READ name WRITE set##uppercasename NOTIFY name##Changed) \
type name() {return m_##name;} \
void set##uppercasename(type n){if (m_##name == n) return; m_##name = n; emit name##Changed();} \
Q_SIGNAL \
void name##Changed(); \
private:

#define JWMINMAXPROPERTY(type, name, uppercasename, defaultvalue, minvalue, maxvalue, loopvalue) \
private: \
type m_##name = {defaultvalue}; \
public: \
Q_PROPERTY(type name READ name WRITE set##uppercasename NOTIFY name##Changed) \
type name() {return m_##name;} \
void set##uppercasename(type n){ \
if (m_##name == n) return; \
m_##name = n; \
if ((m_##name > maxvalue) && loopvalue) {m_##name = minvalue;} \
if ((m_##name < minvalue) && loopvalue) {m_##name = maxvalue;} \
emit name##Changed();} \
Q_SIGNAL \
void name##Changed(); \
private:

#endif // QT_EXTENSION_MACROS_H
